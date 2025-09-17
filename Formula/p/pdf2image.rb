class Pdf2image < Formula
  desc "Convert PDFs to images"
  homepage "https://code.google.com/p/pdf2image/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdf2image/pdf2image-0.53-source.tar.gz"
  sha256 "e8672c3bdba118c83033c655d90311db003557869c92903e5012cdb368a68982"
  license "FSFUL"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "3441323b63b2667e68a90b70633c40813b10f0597933aadd8a46ff7a36413f8a"
    sha256 arm64_sequoia:  "412c25b88af18ef42fc4c705a409449b38f3fab9a792b40067ce2c510e524903"
    sha256 arm64_sonoma:   "caf804519e1009c069f081987d8cf3a9052649c7fa2359bf9749df195bbdbb21"
    sha256 arm64_ventura:  "fd39ba0dc18b50fd76f8be5b8d85335cc2b7fc40ab14e3a096890ed60f6f50b1"
    sha256 arm64_monterey: "0794342647f54210c52fef1f96675b041240c046011a2cd2f1f10ccdd5e0d726"
    sha256 arm64_big_sur:  "283b9a01c14033bac12d833765cdcf81d896a4df12c6a9c7ac5467c340591f1e"
    sha256 sonoma:         "cbd829422ed134b39732586a0a439ee2a3322e27590eb5eb9503496e1dc8320a"
    sha256 ventura:        "ced2743201d3c6f3d2f449cebee65dce9d3348f0643f82ada1be3834090895df"
    sha256 monterey:       "dd02bfaa0f17e894f94ddae7848a7ed0d769a631b294b853bcab234be626c704"
    sha256 big_sur:        "51717dc099723d65d1aeedd18be5886fdb228dca2ceb190cde744a63e1b51bbf"
    sha256 catalina:       "9550e644b89b03d2e78880145d64446d1fe07ef575c2fd4109a932ef2d5258b0"
    sha256 arm64_linux:    "7b1588d8a5fb1c0dac620c9bebada39b426bea18c9310c9bea1de7586885a381"
    sha256 x86_64_linux:   "86497b2d47fec1c951e40a9ed363e8826ded682eaf6d36403ab394f0dc09e7ff"
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
    system bin/"pdf2image", "--version"
  end
end
