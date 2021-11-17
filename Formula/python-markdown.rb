class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/e8/62/6137b2d0b5d69e80004373fac8e84735c975b4a63d4bcab237012e6b486e/Markdown-3.3.5.tar.gz"
  sha256 "26e9546bfbcde5fcd072bd8f612c9c1b6e2677cb8aadbdf65206674f46dde069"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93492746ee664f8ac52c7b183910a1194e4301683c977c2aeb71c172e5119796"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0926148f224393a9d718e9ae032d503af50e4651aa799aacfcd6ae234f4909"
    sha256 cellar: :any_skip_relocation, monterey:       "72e6cea45020e5c5cad848c72ca1a90debba6347a38cddedcf29375f2a5920f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "17410bd96abac23079f5746f78077457b2abed0fafeb544f0b0e28ee23451587"
    sha256 cellar: :any_skip_relocation, catalina:       "cd69e83d7367882f20a1704c583ea03f8b70af2b9e4b92d6575eaea674951c62"
    sha256 cellar: :any_skip_relocation, mojave:         "4c511d30c1aac5d2db8bc48143cee680c5cfc0447aebf25e225270a1e54ada4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16cf6291aa7788af874d97da72492b7de0dc16c2eaa15c4d11a39ad2cf756a96"
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
