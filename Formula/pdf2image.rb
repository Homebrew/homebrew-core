class Pdf2image < Formula
  desc "Convert PDFs to images"
  homepage "https://code.google.com/p/pdf2image/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdf2image/pdf2image-0.53-source.tar.gz"
  sha256 "e8672c3bdba118c83033c655d90311db003557869c92903e5012cdb368a68982"
  license "FSFUL"
  revision 1

  bottle do
    sha256 "51717dc099723d65d1aeedd18be5886fdb228dca2ceb190cde744a63e1b51bbf" => :big_sur
    sha256 "283b9a01c14033bac12d833765cdcf81d896a4df12c6a9c7ac5467c340591f1e" => :arm64_big_sur
    sha256 "9550e644b89b03d2e78880145d64446d1fe07ef575c2fd4109a932ef2d5258b0" => :catalina
    sha256 "00f2f25eb5580dc2a4bbab2ac2913fea732967098cd373e52b6f5317098d8936" => :mojave
    sha256 "622e0f3caa2eeffe59384682a196fd42b381e638d67ddb399e39342e08fee1b1" => :high_sierra
  end

  depends_on "libx11" => :build
  depends_on "freetype"
  depends_on "ghostscript"

  conflicts_with "pdftohtml", "poppler", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # https://github.com/flexpaper/pdf2json/issues/2
    inreplace "Makefile", "/man/", "/share/man/"

    # Fix incorrect variable name in Makefile
    inreplace "src/Makefile", "$(srcdir)", "$(SRCDIR)"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2image", "--version"
  end
end
