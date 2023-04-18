class Pycodestyle < Formula
  include Language::Python::Shebang

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/2.10.0.tar.gz"
  sha256 "a7306561f1ddf7bc00419b9f0d698d312a8eaa173b834e7c8e4ff32db5efd27f"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c7fc7f468096461c73a2659dc705ac6ec26031e028d633f6ef6b6f58f44c18b"
  end

  depends_on "python@3.11"

  def install
    rewrite_shebang detected_python_shebang, "pycodestyle.py"
    bin.install "pycodestyle.py" => "pycodestyle"
  end

  test do
    # test invocation on a file with no issues
    (testpath/"ok.py").write <<~EOS
      print(1)
    EOS
    assert_equal "",
      shell_output("#{bin}/pycodestyle ok.py")

    # test invocation on a file with a whitespace style issue
    (testpath/"ws.py").write <<~EOS
      print( 1)
    EOS
    assert_equal "ws.py:1:7: E201 whitespace after '('\n",
      shell_output("#{bin}/pycodestyle ws.py", 1)

    # test invocation on a file with an import not at top of file
    (testpath/"imp.py").write <<~EOS
      pass
      import sys
    EOS
    assert_equal "imp.py:2:1: E402 module level import not at top of file\n",
      shell_output("#{bin}/pycodestyle imp.py", 1)
  end
end
