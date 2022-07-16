class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
  sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d3ac4ef942f4b316f5f7fc70fd5e84d2f11854d983fad86ffbf5088d9d52d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecf032f9bcd6c4951c8460933b5ce77929b9921aabcccdb902d89cd7947b5100"
    sha256 cellar: :any_skip_relocation, monterey:       "7c0fc31fedf83687330b982bf5cc8a0f8ab37bdfe1237866832ba1794e90d0db"
    sha256 cellar: :any_skip_relocation, big_sur:        "43cd65bb521ae69854123efe0c67581be69782b9f962ee66c31e95ac4ea943b6"
    sha256 cellar: :any_skip_relocation, catalina:       "80bb1c032f4eb2c2c6321623f273ff90aa04d1ae6b9a32dce48b80678ef7ab88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8cf1bc63bd2effe8e6f4ae7ba0f6680e4f0d238c7e969b6fdf98994b83e67f"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
