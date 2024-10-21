class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/refs/tags/v2024.2.tar.gz"
  sha256 "d99c5963d802edf1516a6301a5275edd54014bea2ca924f8752aacab0cdd23fd"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8a8368638da5e8e7ae55bb10b565286afc2f8bb5766c21e35c75cec45f7c94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b032c18a6228d824352383052add8119485dcd99812fcf231165c7aa06bb5faa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08c2b9a4172079624fd579ecc4a76b4f609bb366f5eddb24bc48553c05039113"
    sha256 cellar: :any_skip_relocation, sonoma:        "87200d874aee7ca04cbe5367ee83191b5236541f75be3967ea9fcd0d9bb28b52"
    sha256 cellar: :any_skip_relocation, ventura:       "f657cad51fa143b1cfecaad1ef3ae36db841dbccc99034529b6dcac204c6238a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756050ee203d6141e5fca77079622ede6df503ae6264ac330611299ed875bf5b"
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
    system bin/"latex2html", "test.tex"
    assert_match "Experimental Setup", File.read("test/test.html")
  end
end
