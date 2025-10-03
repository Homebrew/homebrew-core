class Netlistsvg < Formula
  desc "Draws an SVG schematic from a yosys JSON netlist"
  homepage "https://github.com/nturley/netlistsvg"
  url "https://github.com/nturley/netlistsvg/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "b7f218f9d8f2b826d28bff6ebe1f5b1a4fb5b7c9465a034ae0a8fcd2b9d53a67"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "13485ed6f7d18a5733d709b8806159803cbfcfa7bf1afaa6b0e3acd9a12fc200"
  end

  depends_on "yosys" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"dff.v").write <<~VERILOG
      module DFF (output reg Q, input C, D, R);
      always @(posedge C)
        if (~R) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
      endmodule
    VERILOG
    system "yosys -q -p \"prep -top DFF; write_json dff.json\" dff.v"
    system bin/"netlistsvg", "dff.json", "-o", "dff.svg"
    assert_path_exists testpath/"dff.svg"
  end
end
