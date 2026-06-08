class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-53.1.0/apache-datafusion-53.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-53.1.0/apache-datafusion-53.1.0.tar.gz"
  sha256 "7261f3660f351ad33a0d3c3d7a6666eae5bfe242f609cef4868d6449e526ac7f"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "868e0c713ca6d6a6a84e10fe263c3ecc5f854f99b71e79cc60ab42cc65620d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de295d7fc7a00c0e6fb85c92bd15a6bd069b79512564abe48ec60eeecca45a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae43020dcde9626fb3577f48646115525d2a4046db6655a403c61d6a167d7a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f48e6f9a73813eb775e6053820d6832be1566359d2bd0b9f14aa3b5c2aaf121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec5f22350b3aa8789c6fa9544c4cc6e2d5ddee9b84f6423e1860cef9d05edf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1344697ab032003675e206210c438dcf3739135a4b6d87af928875aea69e52d"
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
