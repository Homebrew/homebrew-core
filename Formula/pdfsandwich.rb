class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.7/pdfsandwich-0.1.7.tar.bz2"
  sha256 "9795ffea84b9b6b501f38d49a4620cf0469ddf15aac31bac6dbdc9ec1716fa39"
  head "http://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b298e9deb1b4b62ebfe4eca95b678aff27f9ed76b6f0b13dd6ff9679768cba2" => :mojave
    sha256 "2471d2ff0242228e150a825e08b051803ffa96442c2949155d89aa5ab0163e0c" => :high_sierra
    sha256 "55481ac412ee714452c1ef754718e28a215c395106fac5eb25c07d5908c38603" => :sierra
    sha256 "af5eaeb89d1e89eb0fb48d2e1661ddfdc21c3f35f08cbfb4fb3aff594b4ab1da" => :el_capitan
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
