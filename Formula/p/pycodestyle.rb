class Pycodestyle < Formula
  include Language::Python::Virtualenv

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/refs/tags/2.15.0.tar.gz"
  sha256 "3cb6afba1667f13b4ca7884154299108ef8e633a36526e29412a5cec7b5db4bd"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "23bba1a658123f9af07884ad7525f0226fc61b13e2941ce4434bc291321f56c3"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    # test invocation on a file with no issues
    (testpath/"ok.py").write <<~PYTHON
      print(1)
    PYTHON
    assert_empty shell_output("#{bin}/pycodestyle ok.py")

    # test invocation on a file with a whitespace style issue
    (testpath/"ws.py").write <<~PYTHON
      print( 1)
    PYTHON
    assert_equal "ws.py:1:7: E201 whitespace after '('\n",
      shell_output("#{bin}/pycodestyle ws.py", 1)

    # test invocation on a file with an import not at top of file
    (testpath/"imp.py").write <<~PYTHON
      pass
      import sys
    PYTHON
    assert_equal "imp.py:2:1: E402 module level import not at top of file\n",
      shell_output("#{bin}/pycodestyle imp.py", 1)
  end
end
