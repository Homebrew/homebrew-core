class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/refs/tags/v2024.tar.gz"
  sha256 "554a51f83431683521b9e47a19edf07c90960feb040048a08ad8301bdca2c6fa"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7df9f064562fec47973c8cf86aeda695d9c47afc538141972e4423606fe531ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f51edb7b0b1c5e91a3920324770d0140dabd25463a47a2637326cea1eb6ef096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ac8a480f394fa974959d53a32fffb93ac1cfabce1e3fb391cb664742a8fae1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f841da77f49f00b9a8a8414b4409d5fea0a0b2176fa398ec897af94f741a9791"
    sha256 cellar: :any_skip_relocation, sonoma:         "a125f130e4c05ed129abf0f22e5c57cf93964af9f62b27324ccc2df69a72ffd4"
    sha256 cellar: :any_skip_relocation, ventura:        "a37239f2570dda92f06b72b76df67e98f0746999294aa91a675736d85caf8e15"
    sha256 cellar: :any_skip_relocation, monterey:       "c88bf6e30994439a8791def38f7d4d0cc4b6514d2e19ad3ba32cf2e03a701d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39c72d2b7f896dd2fa3b9c55e14ee0e857f1df963af5f26d1f79e8de71c36cc0"
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
