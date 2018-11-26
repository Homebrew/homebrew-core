class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2018.tar.gz"
  mirror "https://ftp.gnome.org/mirror/CTAN/support/latex2html/latex2html-2018.tar.gz"
  sha256 "09e37526d169e77c266c23122348998a0841c3d50866e45ff2550128157ad4e2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "568e3011aaa4001dac06b7c75d652817664c77cafc10b4260a4dad1426b987ab" => :mojave
    sha256 "85d6f0725f609bcb997296d58304a466b8a0ae7a21440953f822feea0b34f05f" => :high_sierra
    sha256 "f1ee587fcf18d7c94eff2e0cc377e255f7a6c3495558438227e74a51d66a71d8" => :sierra
    sha256 "484dc0ebe2273a16cf1f35bd76a1ef551eee16406fd5927d551c86a7a788212e" => :el_capitan
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
