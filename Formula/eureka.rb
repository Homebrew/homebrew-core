class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.7.0.tar.gz"
  sha256 "3a4475fcce16acdb5bfc705641dbfc99ab7d8d7739de1da44d1f9c2fec8ea92d"
  license "MIT"
  head "https://github.com/simeg/eureka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78923a432ed0b00a266aba6680ad1b1c948e7c31a74b32babad1ffe45bc7dc20" => :catalina
    sha256 "88b2371865f81cf092a3ab85c757bba880a3e3aef9c379ef880972fb75f80d93" => :mojave
    sha256 "ef7f1bde80157ad17a9a789028bd0b0fee6e62f93f66b545a15c8bd753a58767" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [FLAGS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "homebrew/README.md: No such file or directory", shell_output("#{bin}/eureka --view 2>&1")
  end
end
