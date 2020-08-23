class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/44/30/cb4555416609a8f75525e34cbacfc721aa5b0044809968b2cf553fd879c7/Markdown-3.2.2.tar.gz"
  sha256 "1fafe3f1ecabfb514a5285fca634a53c1b32a81cb0feb154264d55bf2ff22c17"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5a1565cdb0c20aa5d1101039e8ed69110dd36262224ed6e2ee107a6d6a0cdc3" => :catalina
    sha256 "54d88c62588de8fef562e815b9cb0e83177798c9276b881401b4445e78605872" => :mojave
    sha256 "80a8cba20c744e0e49f211240883b9f8fbbd0676c95e9f43abbaf1b290f435b0" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
