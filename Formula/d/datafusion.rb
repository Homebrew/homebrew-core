class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-52.3.0/apache-datafusion-52.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-52.3.0/apache-datafusion-52.3.0.tar.gz"
  sha256 "6575236cb18bc91f9dc0da218439a11321873e28bcfae130b96356f2e1f71549"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2999f25ead7952b9aceb5ef34a7365d6b810c8e327081de6ee603d1014ff5c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a6126a5efdb8485c75ff45873df47dfd2e90fdd23bb542f80ea6d3a1d647d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68a40005650f14ef48e5a65c18004c145c387979f926cb49239482ee185fb5fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb5b30c63a3872e0e712ce5e0305e83917db1241b18ae758c61e623a87ec857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3597f2b8707036e61d5dbb053e92ad51f3022d5373cd5f2cc6e95059fefcefb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1849a9d01cfd370fc91835907dfd49f9287cef28d1b925a2dea78e8d76fda062"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
