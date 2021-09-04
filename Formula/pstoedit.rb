class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.77/pstoedit-3.77.tar.gz"
  sha256 "9a6c6b02ea91e9f836448ccc5a614caa514a9ba17e94f1d6c0babc72a4395b09"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "9646c975ae5a9f2d4b9f275f35f66209c039caee11cb110006268e32514f3a5b"
    sha256 big_sur:       "c76b47283e6032cc1a03a3fbd36336df45cc9ef7c9b9754cfcd24ca84a33ebdf"
    sha256 catalina:      "0c90597e74d743451a0df04969f2f4a424b275b75121d05f2f4da7b5a68dbe82"
    sha256 mojave:        "9835ffc2e2099f4e0eec8ae34b89a24678d6a360537c529347bdad5efa9b00e6"
    sha256 x86_64_linux:  "554a5ef2692a5dafbba4b1412ddb34038b61a93b60d31b7ba4ff142dd18584c0"
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  on_linux do
    depends_on "gcc"
  end

  # "You need a C++ compiler, e.g., g++ (newer than 6.0) to compile pstoedit."
  fails_with gcc: "5"

  def install
    on_macos { ENV.cxx11 }
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
