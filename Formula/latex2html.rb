class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2019.tar.gz"
  sha256 "095b6d43599506aa0936b548ee92c7742c8b127d64e3829000f7681a254a7917"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a8631d720a4628e09e09448e866504d01cb3a26e8ea7bc20620199e01b0cbed" => :mojave
    sha256 "488549a6634ef38ec4c7493e1649d2754d40fa1b200fd9f2ab33ec12e1fd6572" => :high_sierra
    sha256 "d3019ab7c34e06538dd3c24c4fae92bb212abf165144e84589bf8af9af54fdc3" => :sierra
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
