class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/26.0.0.tar.gz"
  sha256 "c440f071facb3b0fb71c3884b235be4cea28af48607b3b544165de1f980a8197"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be8ce348f8529f97a0f4e8590319c257dea12563687068b62940dec72340b859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adaef260a94845c1100d33025375a4e742ae5558fce7eb2a949660373686394a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf95fac2d9b96cb5aab490843c50e838ebe899edce9147e4f3ea8c9b0e4b529a"
    sha256 cellar: :any_skip_relocation, ventura:        "8510f7e7892c45239836ecc100f919501b744ea7026d9c43f411d44fd7d3e13b"
    sha256 cellar: :any_skip_relocation, monterey:       "149f319b76fb032ad9d410c164248ccc261313e92dcc4805242eabdd4e1f23e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "75f5a642925edaa4f438528d02101dff68b34a8b313162a7e1e3cc2bf9d3b6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc72f03fb4b83aee3ea9dcb1a994f63b419318bfb91ddb9bd8f401a29913c0b8"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
