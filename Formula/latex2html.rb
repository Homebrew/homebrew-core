class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2020.tar.gz"
  sha256 "414194e7c5164b447b72e1f70b9cfe3e2aeb0c60d81a84def6a8a08bf47c3771"

  bottle do
    cellar :any_skip_relocation
    sha256 "67047d5b5d62383ce1aa89f7e686f597cc5681f73f70ff4cbcca7adb501a2fde" => :catalina
    sha256 "09197aae2b56daffdec8b1310524a54bf5f150ba6b01028f9fbd9fc826a024ca" => :mojave
    sha256 "505bfd350877a8cac8dbe37e3fc40eee907b896a1309ec379ba02ceabb32d929" => :high_sierra
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
