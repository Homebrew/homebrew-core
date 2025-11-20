class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/refs/tags/v2025.tar.gz"
  sha256 "d6f4e9f674994c82cbdff5a39441258add4a8822087fc0d418c0a697dbf3d191"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "834f307a489c9aca2348415e421ffc0abd801c501f85fd54a8672ea8c0ebe646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17359f64ba9559377a577436aae9ef6c06a785ea4e20211354c2ec535ead3252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f65e97b803180688a72967591e566bf69017534278f1a53510b99bb726e129a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "167d02851e14c9c60d894dc40c32bc263dd2eac9356023d67123eea9f5197b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "07acb63ae7523f8a1d3f389a155966303ed115ef9b3601a41adba50599cc5a8f"
    sha256 cellar: :any_skip_relocation, ventura:       "e0d9a77d2410693bb2fe2d55e8dbfba133f8ee636a35948f71eb789b2c5168d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c68c62432cff6fb7f8b197127af925705e61fbec1873d31e281e930855a1b39b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a492ae0e47fef2bb2331f68488a82d22cab36afb649c82af28a34b5532b8e0e"
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
