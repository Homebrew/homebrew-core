class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/25.0.0.tar.gz"
  sha256 "ae704ecfa7e0a00c8cbe8cd57c51da0817b85852b5b25b58990d14c41517f476"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb5fe18876d37c9cba3952bc9d4d2c1156f5095fc66dc982b4f8a2eb8b11c232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a623eddb8361e9634e1e247a3719d1230d28fc46f9132a879b58b3efc86366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c9fce983fd74febb21d319db8d5f5cf1974378a82a49cbefd90c87c6db4871"
    sha256 cellar: :any_skip_relocation, ventura:        "32c53ff9b7cefed121b494cddbc805c8ddeb84dc6d5a7faacbb0e37f37331e6a"
    sha256 cellar: :any_skip_relocation, monterey:       "1165b84e10829fe78d9cf09d138b1051c5306a2c1fac1d98cb4714b022b1f3c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f146eca5fd8296bcdd08585fc0aa8c1a2e815cd1b2e4227a461dbff3b6c0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e580c378fceb6437d9290914bb1235dc752abbabc02e3f7d146e245761e793"
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
