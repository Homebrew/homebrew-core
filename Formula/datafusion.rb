class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/9.0.0.tar.gz"
  sha256 "dc18b4e30510f2c8fe6befc49d2afae800af46d5807536505e485d21bbff6097"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "254c4c8d11f455d1a3d3f50034aad0e43ed7eabbcd5138210276f999b572bf31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c169ec289bf00dfaca36e8ce730ee2690bdcf39e653ca5b464cc8466168b5ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "bd505850bfbd6f17d847f95fd75eabcee788e924fc92cc377d3f7cec2afb60a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1229a55a6d99e76da427ced1e24843b83305474cdd8c67cd14455fd449357d8"
    sha256 cellar: :any_skip_relocation, catalina:       "70d52f0a0a1730a8a732cc14cdb0631cdad0668574dfc403ce9c7b8b2cdf2373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab9840315b950ce612e2ee5849767adf820739e9dcd7b5017557e7662bc2c70"
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
