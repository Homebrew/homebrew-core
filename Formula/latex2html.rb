class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2019.tar.gz"
  sha256 "095b6d43599506aa0936b548ee92c7742c8b127d64e3829000f7681a254a7917"

  # must build from source to configure executable path.
  bottle :unneeded

  depends_on "ghostscript"
  depends_on "netpbm"

  def install
    ENV.prepend_path "PATH", "/Library/TeX/texbin"
    system "./configure", "--prefix=#{prefix}",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end

  def caveats; <<~EOS
    You should have a TeX system installed beforehand. If not, run:
      brew cask install mactex
    And reinstall this formula.
  EOS
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
