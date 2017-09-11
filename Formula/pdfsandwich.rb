class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.6/pdfsandwich-0.1.6.tar.bz2"
  sha256 "96831eb191bcd43e730dcce169d5c14b47bba0b6cd5152a8703e3b573013a2a2"
  head "svn://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  depends_on "ocaml" => :build
  depends_on "gawk" => :build
  depends_on "tesseract"
  depends_on "unpaper"
  depends_on "imagemagick"
  depends_on "exact-image"
  depends_on "ghostscript"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath/"test.pdf"
    system "#{bin}/pdfsandwich", testpath/"test.pdf"
  end
end
