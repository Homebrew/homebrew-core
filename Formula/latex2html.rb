class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2019.2.tar.gz"
  sha256 "a76066632ebe416c770a2ce345d670da846e9f3d89632d6acd6e57fa6b4e264a"

  bottle do
    cellar :any_skip_relocation
    sha256 "91e4717349a40f64e24557adb2dd55b8cd14d996ddd1dda9e5b040317000a247" => :catalina
    sha256 "f6dee60d59252f2f582eb9c7f44f8b69809c649a362014d73f228a5f7c450f81" => :mojave
    sha256 "5761ce11f487165b9ad54777b0702b88d8c8c18d2ac099f5ea8391102a055695" => :high_sierra
    sha256 "b6e2c087c2aec7650e4157c35b7e5e40b82b4bc606aa93a8e04031c99b1b144a" => :sierra
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
