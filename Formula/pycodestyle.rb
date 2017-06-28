class Pycodestyle < Formula
  desc "Simple Python style checker in one Python file"
  homepage "http://pycodestyle.pycqa.org"
  url "https://github.com/PyCQA/pycodestyle/archive/2.2.0.tar.gz"
  sha256 "aa663451c9de97d00eff396eeffe1095fd1597491341ca3c0be54983b25b1a7d"
  head "https://github.com/PyCQA/pycodestyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "633de9fb071d5de9c2a80b4a5bb412d38f3e3641a18cdcd0538af0054bd062f7" => :sierra
    sha256 "5954ba6c8de63ba0cfde28f59a74cfaaf06b650f26b030ae189a75f7616bea79" => :el_capitan
    sha256 "5954ba6c8de63ba0cfde28f59a74cfaaf06b650f26b030ae189a75f7616bea79" => :yosemite
  end

  def install
    bin.install "pycodestyle.py" => "pycodestyle"
  end

  test do
    # test invocation on a file with no issues
    (testpath/"ok.py").write <<-EOS.undent
      print(1)
    EOS
    assert_equal "",
      shell_output("#{bin}/pycodestyle ok.py")

    # test invocation on a file with a whitespace style issue
    (testpath/"ws.py").write <<-EOS.undent
      print( 1)
    EOS
    assert_equal "ws.py:1:7: E201 whitespace after '('\n",
      shell_output("#{bin}/pycodestyle ws.py", 1)

    # test invocation on a file with an import not at top of file
    (testpath/"imp.py").write <<-EOS.undent
      pass
      import sys
    EOS
    assert_equal "imp.py:2:1: E402 module level import not at top of file\n",
      shell_output("#{bin}/pycodestyle imp.py", 1)
  end
end
