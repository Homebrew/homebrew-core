class Netlistsvg < Formula
  desc "Draws an SVG schematic from a yosys JSON netlist"
  homepage "https://github.com/nturley/netlistsvg"
  url "https://github.com/nturley/netlistsvg/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "b7f218f9d8f2b826d28bff6ebe1f5b1a4fb5b7c9465a034ae0a8fcd2b9d53a67"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8631b57e56cacc86f90f5ffec484dbda8fc3e8ed679bdb5549d62f4e8fc87519"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8631b57e56cacc86f90f5ffec484dbda8fc3e8ed679bdb5549d62f4e8fc87519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8631b57e56cacc86f90f5ffec484dbda8fc3e8ed679bdb5549d62f4e8fc87519"
    sha256 cellar: :any_skip_relocation, sonoma:         "8631b57e56cacc86f90f5ffec484dbda8fc3e8ed679bdb5549d62f4e8fc87519"
    sha256 cellar: :any_skip_relocation, ventura:        "8631b57e56cacc86f90f5ffec484dbda8fc3e8ed679bdb5549d62f4e8fc87519"
    sha256 cellar: :any_skip_relocation, monterey:       "8631b57e56cacc86f90f5ffec484dbda8fc3e8ed679bdb5549d62f4e8fc87519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375b90caacd7736ea74c7f6ebfc1b0fd5b4c8bde7a75be4e12e965b0221d4f1e"
  end

  depends_on "yosys" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
