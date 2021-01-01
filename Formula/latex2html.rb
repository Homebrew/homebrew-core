class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2021.tar.gz"
  sha256 "872fe7a53f91ababaafc964847639e3644f2b9fab3282ea059788e4e18cbba47"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d9e1606ef1316a3945c6b17b7a327c0f3afd6ee98573924d55ceae911d555614" => :big_sur
    sha256 "a4715be27091456b513e38075f42a88428ee9fd3a05aefc4cbbacf937b7f0017" => :arm64_big_sur
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
