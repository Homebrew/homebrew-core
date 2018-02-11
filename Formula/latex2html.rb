class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2018.tar.gz"
  sha256 "09e37526d169e77c266c23122348998a0841c3d50866e45ff2550128157ad4e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "051de8192f7caaf9a2e2413e8cdb3f9878d1bb2e03200ffbb1ab42e3a78cb005" => :high_sierra
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
