class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
  sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2769293a7454b35d7f75479ad103d707a0381bcfdc33bbb29959c12aefa9e1b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff572b2a634ff50fd3f3ed624abc1373688b69a4fc86df145551f9de65883d74"
    sha256 cellar: :any_skip_relocation, monterey:       "94a10dbb13fd3ef84d4e17fc7a05e1cbbc35df891f162238dcdd0d6c4d9deed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "79e8b93951a7398cc782fc44eb631112a512017852b9aa8513a61e677cbb9272"
    sha256 cellar: :any_skip_relocation, catalina:       "51a5b491a577e86a32e8b54f4be3cc7aa46a89e8d832cf57323afda27f43a8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2badf01076b76fa01791be39f2db662763a5254ca1a715eab4060b178eea583"
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
