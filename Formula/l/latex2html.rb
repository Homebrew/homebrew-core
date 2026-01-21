class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/refs/tags/v2026.tar.gz"
  sha256 "f91c0c9bc8dbcadbba883f912f9d1cd2382b563fd754456488a95c120f24331e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4eab1a95e9acbb8c752f81b1edcf03f4f0f0cb287c8c865fb565f68e722075c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7faf0c531948aa38a9bb1025c69c82ef0b66f4c74c2e1b5a6de4239dbd8ab179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500bad6a08f2ca7f94d3ce34f5c9e441b9ec1436afc9626d783cc45a354f521f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b75fab8d6cc429e7d328bc62b6a677f259fe89cddbd74382b609932d99546ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb5fda4ff20cacc7e15cabac8d97e860679d03a9b4c3c07196249500bfae1514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4707cdb1549e57bd8b2f89dd533e9d76fcc99ae6461a251ee574703d32533bc3"
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
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \usepackage[utf8]{inputenc}
      \title{Experimental Setup}
      \date{\today}
      \begin{document}
      \maketitle
      \end{document}
    TEX
    system bin/"latex2html", "test.tex"
    assert_match "Experimental Setup", File.read("test/test.html")
  end
end
