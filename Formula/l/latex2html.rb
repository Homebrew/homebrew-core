class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2023.2.tar.gz"
  sha256 "2a3f50621a71c9c0c425fb6709ae69bb2cf4df4bfe72ac661c2ea302e5aba185"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0177499970c3270901c2fba2d994af5bfe51344c60a1a7f90593f79e53106521"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "741063e2b363375f432558c70beaa845e298a60c786324036855304ae8c9df85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c4baff8ee289ed0f1f31939eeceb8ff76ed387ea00edd9fc159ab3b166f1ce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd913b99fe165733119e611c364dc2ee437469744f31c94e343061fdcf2de274"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a72e3fe8bae7862e53d8665b6b49bbf9138cbabe7e4dbb101a5405e65ed283e"
    sha256 cellar: :any_skip_relocation, ventura:        "2db51f723dfc5256ee97568c8c713dda25afb0f22fc0d7fcea46b8b8c91c9157"
    sha256 cellar: :any_skip_relocation, monterey:       "61835085167c5e79d4cfa7184f1bf0b797087982ec41363f90cb0630df013953"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ae2a9157d855667ff3da167f8a109cfc8ce6a0193f77ed79b8708062f1af69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c501886d5917ea35433006e65273f16104dcd720157317a2a86e6fa6b213e92"
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
