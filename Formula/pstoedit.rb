class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.71/pstoedit-3.71.tar.gz"
  sha256 "0589cd22cd9c23dee12d9bc9f26760f872185d8a1fb72a05bc58f6b824cfbc95"

  bottle do
    sha256 "319234b9126aeb338850b4d9bb2db68da75bee8d2025894726897976b5e4633a" => :high_sierra
    sha256 "085860d9480d7d9558697d403f6628466a8fdfe52f568f21793568d1c71747f2" => :sierra
    sha256 "ee6634e964c7687c5614c9e4358737154ab6f29d53a104416bdc1509b33e6930" => :el_capitan
    sha256 "6330be58259fcfa74062eb1ebfa5eced31aea86ae5f1ce6b2bf49e2f544b3d73" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "plotutils"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "xz" if MacOS.version < :mavericks

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
