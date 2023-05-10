class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/24.0.0.tar.gz"
  sha256 "34b4565e0464cccd8c7626730f61579beb4ab8d9fec3d8da0bb82df767e8eea4"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b8a1cfb6b2b88f511045e1cf56cf746fde0d3ad93f2384adc382f857fe5d49c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00ec381d24c28e515f0192ce3758a046f528f4ab4a1ec6483ff99a720c64675c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b483ada94d09ccef6dbb13b0e49f6928dea44b5c5778450db45fddbafbbb01c"
    sha256 cellar: :any_skip_relocation, ventura:        "6c738db92be21b4334a90e64101be8fa117010873dc4de9a477df1d556f506df"
    sha256 cellar: :any_skip_relocation, monterey:       "3b9df63fad1b33ec5854a18a13261675e0e170018f8e4d6ec7394ca90f2cc097"
    sha256 cellar: :any_skip_relocation, big_sur:        "25d4633429ff64584796ebc1ea8ac74e311c8658e19260bc29f2c4190676e522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9602aaed026f7f634d0ff7d5ff3052cc1c1bc4092adefb840c5483c7f9a19b3"
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
