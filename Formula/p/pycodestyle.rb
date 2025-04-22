class Pycodestyle < Formula
  include Language::Python::Shebang

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/refs/tags/2.13.0.tar.gz"
  sha256 "b1a4db0d9b8285f6643bcdb41362be6d6c94b891b13ead09c57a2513c46b717b"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8318ea63471f50206c5957f21508ee39131d6a8090162da679838386d98bc85"
  end

  depends_on "python@3.13"

  def install
    rewrite_shebang detected_python_shebang, "pycodestyle.py"
    bin.install "pycodestyle.py" => "pycodestyle"
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
