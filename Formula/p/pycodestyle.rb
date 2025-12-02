class Pycodestyle < Formula
  include Language::Python::Virtualenv

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/refs/tags/2.14.0.tar.gz"
  sha256 "ffcf4dc55f1e5fbdc6dd6acf5db0fd07ded534ae376eee23a742e1410b48d9ae"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cbab819ac63a266ecb40a5cf66d17f03c9acdff4c17eb44aa102a5cf20985506"
  end

  depends_on "python@3.14"

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
