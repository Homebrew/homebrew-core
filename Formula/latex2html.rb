class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2018.tar.gz"
  mirror "https://ftp.gnome.org/mirror/CTAN/support/latex2html/latex2html-2018.tar.gz"
  sha256 "09e37526d169e77c266c23122348998a0841c3d50866e45ff2550128157ad4e2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "921724f29095fc6b3d89a1ed379c330f4f5fab7c29c4665e418b00621aa17a05" => :mojave
    sha256 "1f53664898fb8df9884c207f5b5f7042e3c47069c4e48a519289251fe1c59f2a" => :high_sierra
    sha256 "f4863e230cbd2838bd135e6a806a1fccc0453f033b65e26906f5a164eede7fce" => :sierra
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
