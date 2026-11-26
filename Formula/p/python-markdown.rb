class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/1c/ff/8644daa33bfdf552c9cfec8d1fc2c690f57a347808f62c406ac6557329c2/markdown-3.11.4.tar.gz"
  sha256 "c911a757f33d64a2578bed2d20c57e007b2aedd8a67bceabd593b31143d54ead"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d32d44d24259c81cc73cb52d25be38d84c12ad490bdae34476f0ac78f9013a37"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output("#{bin}/markdown_py test.md").strip
  end
end
