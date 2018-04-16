class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.71/pstoedit-3.71.tar.gz"
  sha256 "0589cd22cd9c23dee12d9bc9f26760f872185d8a1fb72a05bc58f6b824cfbc95"

  bottle do
    sha256 "c153dec1a76f7d6a829276145552fc6dc3756322a3023a24506740ee128d9a23" => :high_sierra
    sha256 "3f4a82c73fcc2c44bfaa043babe85b8a4190de731752a86a2db553fa18c5bc5d" => :sierra
    sha256 "5b4de0d105ec879d80202d8c523e6052769316e29e7eb975f5e2b77b2fc369f4" => :el_capitan
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
