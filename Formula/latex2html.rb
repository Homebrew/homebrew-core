class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2021.2.tar.gz"
  sha256 "892714d87d2ab357488679bda91ae1333b1da6d9743fd42443cc71aaf069cb83"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d8dd368554c0e423354e6bb52795018f2fca7638628dab28b746f52c39d749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f36d7818ab517829c087122323281ac9e66cbcf89a9a105c16f11f6efc7466b"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1123c5c4c1fff6c2c2fc6f1e1f83ac00dd7475700c4f3c26303e26b1448a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcfcf542ab089c183d2e112f92ffb5b5319ca7114fce654923a289cf8978fb47"
    sha256 cellar: :any_skip_relocation, catalina:       "e02b5c3a133eb5d4f3c570dc785aebae13bc7c2af0880cbfe2165cdd80df63a5"
    sha256 cellar: :any_skip_relocation, mojave:         "dd89940ad2d5d7c2e9100a051221b072645f684d0fa73456ca116c315ec7a680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17be21fc177c428856ad769efadb47a2cb2b2a3ab874fa2fbed0f3d776fc9dca"
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
