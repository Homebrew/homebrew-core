class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/e8/62/6137b2d0b5d69e80004373fac8e84735c975b4a63d4bcab237012e6b486e/Markdown-3.3.5.tar.gz"
  sha256 "26e9546bfbcde5fcd072bd8f612c9c1b6e2677cb8aadbdf65206674f46dde069"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc5b68885a95ffd9f15eca4af4dead009d6c281e8b200736463e952d7a5cb70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e52a94d22cae9deb7a1acb182857830b6066fba2fd7cc4ff5523652fad99e47"
    sha256 cellar: :any_skip_relocation, monterey:       "998853b31009384f9169c220c15f24ac6081ba910fa38318970836277c62de67"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c984fc5878f5c11ccd94c5d135ad2cce0c01229c7f5aa7241b62e9cfb359bd3"
    sha256 cellar: :any_skip_relocation, catalina:       "28dcd71857340fb4f04769cff395a25c62d4732d9ebade11c9e359a30e0a6e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181c349d810f7be0801bb1611000ef1b428e16e684baaaf7c8a201c3458a5cbc"
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
