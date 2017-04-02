class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2017.2.tar.gz"
  sha256 "4b8c21ef292817c85ba553f560129723bcae4ee9a6ec7a22ce2289329db7c1ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ef1c505140cf839ae71708e3785812a538622a19ee76c19ec1901b6a4567edc" => :sierra
    sha256 "ee26a1cfa8ff76d1f1d7a0d3435e5a792fbc34e35e43cf84c22321c1df665f3a" => :el_capitan
    sha256 "8c53c049249208b6441c43500b8921c0869b4d0fef6226194ce4e1a8a8c8cbfe" => :yosemite
  end

  depends_on "netpbm"
  depends_on "ghostscript"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
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
