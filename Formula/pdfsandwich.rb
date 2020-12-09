class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.7/pdfsandwich-0.1.7.tar.bz2"
  sha256 "9795ffea84b9b6b501f38d49a4620cf0469ddf15aac31bac6dbdc9ec1716fa39"
  revision 4
  head "https://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eaf634d8505b9420f4c708a89903f2e510321de8ef5de82243e3f7f0f4938fb9" => :big_sur
    sha256 "da87899cec0c1a0d94f702ec5c42082d9bb96a8429323cf9fcc35038a480c5e4" => :catalina
    sha256 "be266ba965ab19b0f8b0069148faa521beb70e24b1608774d9387d75f934bd52" => :mojave
    sha256 "beb4f8fc82b11d7b27f1bb009921484094ff9cb61542321371ce3149729664d2" => :high_sierra
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
    bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["poppler"].opt_bin}:$PATH")
  end

  test do
    system "#{bin}/pdfsandwich", "-o", testpath/"test_ocr.pdf",
           test_fixtures("test.pdf")
    assert_predicate testpath/"test_ocr.pdf", :exist?,
                     "Failed to create ocr file"
  end
end
