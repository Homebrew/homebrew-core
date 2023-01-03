class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2023.tar.gz"
  sha256 "71935a850b44f7db76ff3d0d8e3d06e43f34b7edebf7905e684ef3361dc6974b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c048e82371f99826258510f89248ab8580f74fbff6de8019a83f263d48519348"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9feb7dea84269ec6280fd8038cb77b90e6f069798ffef31553da4a4c9b3c1855"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb68446d1e1122bd644f80cf349e6f6c6602863145704ea8dc31c90d6c2d968"
    sha256 cellar: :any_skip_relocation, ventura:        "5ecab61b77ad54f0db2e2a89317021521d42ce3f6d95e928f89189ecd5bd8c67"
    sha256 cellar: :any_skip_relocation, monterey:       "8e82f0549eb5b8157a636fdacd00cf6a2644b32e7a475c3ad48a836f2a7ff6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "84544e2810c5aae28402832d23a12862cffa2b3be12369ebd5a562e19f5a6f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b462ec8be971d4f2af3c0e887f48afdccf39dcd0d65a8b2e3bca1b474b88a2f1"
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
