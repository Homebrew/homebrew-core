class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.78/pstoedit-3.78.tar.gz"
  sha256 "8cc28e34bc7f88d913780f8074e813dd5aaa0ac2056a6b36d4bf004a0e90d801"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "95d05bfcb5d1ed195c74b93104ebc1891774dec5daae6e91b81fb965a50d7ea2"
    sha256 arm64_monterey: "9f4bedee7e78de9078d4d799cbc52dc799b715668b10977a96d0858e17c024ef"
    sha256 arm64_big_sur:  "a52e8b66f580278acb40be868a259d9e410bea922379fb5244ea63729606f876"
    sha256 ventura:        "e4c711021e252bb34f8dc0f1e204f7253f4567c4f7f89e632813366d0bd78731"
    sha256 monterey:       "578d8dd21d622fef301739b3da93ced074113fd641503f39cb5313671d0d8b4f"
    sha256 big_sur:        "8cf73733366948cd732643dd90b9f8122eb4a3c170961386f8a16f0d3438aa1b"
    sha256 catalina:       "5dcbb6919e233abc953f621b23c536f554fcf497af4aa4b7ce639560e912252b"
    sha256 x86_64_linux:   "0c915e6e038467fb683d484de48d2b61df78f3af0de3b2ca85bb69ef8cc998da"
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  # "You need a C++ compiler, e.g., g++ (newer than 6.0) to compile pstoedit."
  fails_with gcc: "5"

  def install
    ENV.cxx11 if OS.mac?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
