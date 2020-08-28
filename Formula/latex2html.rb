class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2020.2.tar.gz"
  sha256 "09f2d7f086fee9538523fd5074ada8ebadbdbc2227ca11d9d36189e698e5cfaf"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f5448ddd27e175bc6cf388581f3332a188bc52a15c69d41b8002cc5303471cf4" => :catalina
    sha256 "fc170658ac170d9bf484a05d99fc052fdefdf9d39ada1cb0b2cffa20950e7ed5" => :mojave
    sha256 "1057bbb3c6c991e3ce62425b2b11852558d40be5fab478560784ee2b60ec2591" => :high_sierra
  end

  depends_on "ghostscript"
  depends_on "netpbm"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\usepackage[utf8]{inputenc}
      \\title{Experimental Setup}
      \\date{\\today}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    system "#{bin}/latex2html", "test.tex"
    assert_match /Experimental Setup/, File.read("test/test.html")
  end
end
