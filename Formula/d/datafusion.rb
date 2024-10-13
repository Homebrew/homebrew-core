class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/42.0.0.tar.gz"
  sha256 "8c0e0346540f059a5af4facb8a05dc3b41cff7e1d6b0fdf565b3431d6ff4fca0"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a365d51707c1e07568ebb704f0fd8d38a7ade58603d49dfb9df17b992d4e2bd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ecafacb0ba617dbfc650017e0c474ab0c0a4f78834f4d5d9b8c8eeb75b8880"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65676c851ffad3be5cfee53f8c8e7235e285395aab845029f1aca75bd5f870c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e38861f7d6bce2cd0df8dd138c23c41c131a488f35677842a96cef88f525ae8d"
    sha256 cellar: :any_skip_relocation, ventura:       "0190a8e92ecf160790309fb9d1feab7d8bd7317fe6376c58d602da2102f1fcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc71b11aa6956f6deeb118ccddee99b0c035e3ddf5e07f788f5233c2d713b43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
