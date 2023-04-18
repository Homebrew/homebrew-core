class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/9d/80/cc67bfb7deb973d5ae662ee6454d2dafaa8f7c106feafd0d1572666ebde5/Markdown-3.4.3.tar.gz"
  sha256 "8bf101198e004dc93e84a12a7395e31aac6a9c9942848ae1d99b9d72cf9b3520"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb7e84f3bc3f6bd8fae703ed60ff57daaf6ef82383907c872958a1cdfdf6db5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd282bb3955a3e2d64d25ce08f1b22bdf45aeed5b6b47da65abf24ffdf140b41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "673aae28dae095360cd72d5a15c11af1bbd8a3944b647ea35946e9f078c823d9"
    sha256 cellar: :any_skip_relocation, ventura:        "8c1c56d94bb3e8cd156d813d826d2abd72df57836ba9a268f2ecfb13a338bb2d"
    sha256 cellar: :any_skip_relocation, monterey:       "a0abb5fc97a4ae02aeb223a3c628dcb53d1c7cb6c0dc50a220597f357d38dfa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d146410c188f27b4a286783feb03f1b0177ed191a4d6f9909465a5e46b229a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a89ae63cb9d801ab57cbcc5be7d16ff62d1443e60da46497ae392b7e2d4352f"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
