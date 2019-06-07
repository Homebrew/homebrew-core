class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.74/pstoedit-3.74.tar.gz"
  sha256 "353242fa4a3a73c3c856d1122a4d258a12be869707629603807e27137566990c"

  bottle do
    sha256 "44f8a102c1d605669e13f3e36daae3842fb5c43136be27bf858ebdf28d021d79" => :mojave
    sha256 "11f3efb3f5f5aa6912bc34f72be786abbfd176406bf6635166a5057415e6af08" => :high_sierra
    sha256 "83a6324270f93ae5bca3843f52e0ae84050fc72f68c150d3456947b961f4f16a" => :sierra
    sha256 "fd0e52881d4397cbca26f851b2fbbc65b382ee3c70ba46c362b90b30d9280428" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  def install
    ENV.cxx11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
