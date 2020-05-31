class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.6.3.tar.gz"
  sha256 "ba11b03de24fae9909ceaecec1ba5a5bb6c109603192d7273d750d0dcc9b6da4"
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

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "homebrew/README.md: No such file or directory", shell_output("#{bin}/eureka --view 2>&1")
  end
end
