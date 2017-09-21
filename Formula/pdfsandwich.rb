class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.6/pdfsandwich-0.1.6.tar.bz2"
  sha256 "96831eb191bcd43e730dcce169d5c14b47bba0b6cd5152a8703e3b573013a2a2"
  head "https://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b1496789548ad2a0335a22ca7e6ca3995bd8c664783126b8b83fd192f4f9f7c5" => :high_sierra
    sha256 "1192a119a2190852ba71ed21e4144a9610be8f52bddb3dfaf6fde9f2c5348567" => :sierra
    sha256 "b04ebe1a431fe29bbdd5ac1d0885ea9b1d58fff020d097f4edb245756b276f95" => :el_capitan
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
