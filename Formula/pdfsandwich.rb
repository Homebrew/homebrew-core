class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.6/pdfsandwich-0.1.6.tar.bz2"
  sha256 "96831eb191bcd43e730dcce169d5c14b47bba0b6cd5152a8703e3b573013a2a2"
  revision 1
  head "https://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  bottle do
    cellar :any_skip_relocation
    sha256 "48824ed025286aa303ed5b97773a7950911b9960451fda4b4fb6507d840f0add" => :mojave
    sha256 "c9d15595a1464fef2f81fb8407341ade62ad10d0e0c0f02f89a20d0b68fbb55f" => :high_sierra
    sha256 "ed31bc5b7ab23423ae7e94fa26152ae0313061ec5bdfcc2f0cbeaf2a778fa323" => :sierra
    sha256 "2360d92a613c69b69a4b20cc13b081d333c8ee9a48311ffd41ff8a036bc9fcff" => :el_capitan
  end

  depends_on "gawk" => :build
  depends_on "ocaml" => :build
  depends_on "exact-image"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "poppler"
  depends_on "tesseract"
  depends_on "unpaper"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["poppler"].opt_bin}:$PATH")
  end

  test do
    system "#{bin}/pdfsandwich", "-o", testpath/"test_ocr.pdf",
           test_fixtures("test.pdf")
    assert_predicate testpath/"test_ocr.pdf", :exist?,
                     "Failed to create ocr file"
  end
end
