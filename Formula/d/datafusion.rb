class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/datafusion/archive/refs/tags/52.1.0.tar.gz"
  sha256 "8c39f89cd2ae6a1f5e1c98e67ea3d128d5ebc4fd209a73a038ff97de49506442"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f235b29ee9d2c48883ff992ace905bd7fab30741c501b33d9e8a0825c2f1f68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5677e7ece071ca2e8109d110c6d6c09a9337664733bad356fc80207abf8fdf1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425e1c63c211742dfee272ac312d78fe41801e822e56b376c7ae421f771cbc16"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eabb9172b891daf7e9ad38afdc96582446e3b1eadfcf171059997243c34f102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3397041ad09f850889e0840cf7e071939cc91d07b053c962dc355b721a1ca12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6842d4053d5b35018336bf62c4a5c92378fb83e471355759551f820c7217fecd"
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
