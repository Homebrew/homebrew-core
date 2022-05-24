class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2022.tar.gz"
  sha256 "9b3ba484226a2e39fb20695729370372b355f71bd65eeb4dd14f2c78699ed59a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6641561f400242f33c0aa593dafdca76d2c1914bdfa37338907969d1e21c0b16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16c4b37f5a8ed8ba3535b4dd6f310763e75423079793ed18653bff59fa9ddfdd"
    sha256 cellar: :any_skip_relocation, monterey:       "d7fe8a4deeccc36569dc7635a651364055b5dbb8aa0f1fa38141c3fcf6a83657"
    sha256 cellar: :any_skip_relocation, big_sur:        "70f14cb4a800970e48f2bdccb22162793bd650a308617fd83a90011542c4f2e6"
    sha256 cellar: :any_skip_relocation, catalina:       "09624775c9cfa2fd114e9a32915a5330e2d55102076e1bdd2e7eebefa6f89600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d37099d9ed061779a20ff667cc71229ae8f52cadf737bda0af1b7da9b7cbd5"
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
    assert_match "Experimental Setup", File.read("test/test.html")
  end
end
