class Pycodestyle < Formula
  desc "Simple Python style checker in one Python file"
  homepage "http://pycodestyle.pycqa.org"
  url "https://github.com/PyCQA/pycodestyle/archive/2.4.0.tar.gz"
  sha256 "b8656dc08ab4af23d001a42b3f68510d15790df28d7d666d3f91e3fe9bf8e938"
  head "https://github.com/PyCQA/pycodestyle.git"

  bottle :unneeded

  def install
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
