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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9916c409b549719f49e6dc4baa2866cf6a1f313695b9b7f0cc26d3281e40eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe79732ce4286367899079a9f454c57db16c65d46851093ea7b74cd7fcee070b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b8249d8a5645594a8514c0454bd4eabf2cc3e3ba4f2fbf0ee13acfde88a8bd6"
    sha256 cellar: :any_skip_relocation, ventura:        "afc71f8876f06ac633b43b843c1267a21d0ab375c87e0199a53b0ec0e64ba006"
    sha256 cellar: :any_skip_relocation, monterey:       "ca570902e67d6bed65c699855d3644e9601f24208788d4cf57b45b6be98c5fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2de5fd65a590c0ba97c992ae00d50138059b3dc0b25824d8de4c0d6cec0c1c03"
    sha256 cellar: :any_skip_relocation, catalina:       "ec0a808f4b5e62f702f941849063f9290d05522b5039f006a8ba58e7ef029353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6eeb77576c366020b2c5a5b57a2255641632f9129b6491a3389f56d875bf7de"
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
