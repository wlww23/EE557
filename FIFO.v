module fifo (clk, rst, data_in, out, ren, wen, empty, full);
  parameter DATA_WIDTH = 16;
  parameter DEPTH = 16;
  parameter ADDR_WIDTH = 4;
  input clk, rst;
  input ren, wen;
  input [DATA_WIDTH-1:0] data_in;
  output reg [DATA_WIDTH-1:0] out;
  output reg empty, full;

  reg [DATA_WIDTH-1:0] register_array [0:DEPTH-1];
  reg [ADDR_WIDTH:0] wrptr, rdptr;
  wire wenq, renq, depth;

  assign depth = wrptr - rdptr;
  assign wenq = (!full) && wen;
  assign renq = (!empty) && ren;

  always @ ( * ) begin
    if (depth == 5'b10000) begin
      full = 1'b1;
    end
    else if (depth == 5'b00000)
      empty = 1'b1;
    else begin
      full = 1'b0;
      empty = 1'b0;
    end
  end

  always @ ( posedge clk ) begin
    if (rst) begin
      wrptr <= 5'b0;
      rdptr <= 5'b0;
    end
    else begin
      if (wenq) begin
        wrptr <= wrptr + 1;
        register_array[wrptr] <= data_in;
      end
      else if (renq) begin
        rdptr <= rdptr + 1;
        out <= register_array[rdptr];
      end
    end
  end
endmodule
