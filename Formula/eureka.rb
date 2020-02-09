class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.6.2.tar.gz"
  sha256 "a8fb41cdf0c8c5a00e5c17fd2cdde71ce8fa1babb2b5d69d68cee7a0df5d1b4b"
  head "https://github.com/simeg/eureka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac22c59bd6c9359388c17ca6e4f342ef2c9b114539bc6a8547434fe95f2f430f" => :catalina
    sha256 "c4e6550eaba8cbfe179fe58f2a0ed621bbc43bf53c28f56f417dc13020405bd5" => :mojave
    sha256 "2cce6fe9de241d1d78fb1ef7cdc4d1d94e22973da6d0e59bca252d7f039bffd4" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "eureka [FLAGS]", shell_output("#{bin}/eureka --help 2>&1")

    assert_match "Could not remove editor config file", shell_output("#{bin}/eureka --clear-editor 2>&1", 101)
    assert_match "No path to repository found", shell_output("#{bin}/eureka --view 2>&1", 101)
  end
end
