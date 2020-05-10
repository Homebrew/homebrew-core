class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/44/30/cb4555416609a8f75525e34cbacfc721aa5b0044809968b2cf553fd879c7/Markdown-3.2.2.tar.gz"
  sha256 "1fafe3f1ecabfb514a5285fca634a53c1b32a81cb0feb154264d55bf2ff22c17"

  bottle do
    cellar :any_skip_relocation
    sha256 "794749d9f07df8c18e77027ad4962bf607b86b82a2bff7c863fab628e421f0bb" => :catalina
    sha256 "c1b7907a2e382d8bac8811d20d680aeb4da4b26af5a14ccc2399f5eb60b28ec5" => :mojave
    sha256 "f7d01b91d1a72658fd467591800934c03f6041a38ea07d23a16c9a7a42eb5c6a" => :high_sierra
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
