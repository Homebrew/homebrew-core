require "language/node"

class Netlistsvg < Formula
  desc "Draws an SVG schematic from a yosys JSON netlist"
  homepage "https://github.com/nturley/netlistsvg"
  url "https://github.com/nturley/netlistsvg/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "b7f218f9d8f2b826d28bff6ebe1f5b1a4fb5b7c9465a034ae0a8fcd2b9d53a67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0db6e0d42e5a96a82499730ce2be1ae11af72f23b0d16e536eabf2e30c7d8983"
  end

  depends_on "yosys" => :test
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"dff.v").write <<~EOS
      module DFF (output reg Q, input C, D, R);
      always @(posedge C)
        if (~R) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
      endmodule
    EOS
    system "yosys -q -p \"prep -top DFF; write_json dff.json\" dff.v"
    system bin/"netlistsvg", "dff.json", "-o", "dff.svg"
    assert_predicate testpath/"dff.svg", :exist?
  end
end
