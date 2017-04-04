class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now (using - instead of _ in the version field).
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20170228.tar.gz"
  mirror "http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.6.1_20170228.tar.gz"
  version "3.6.1-20170228"
  sha256 "8de2f2ae70f71455288ec85c96a2579391300c7462f69a4a6398e9ec51779c11"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "2ef19b5af334814ba4aa550afa442c52027a848c57fd4d4df351d0112c52877c" => :sierra
    sha256 "0bc092b689f1c076b06ad25bcc3c444942c3b934817f031ab12356ee47a02b23" => :el_capitan
    sha256 "2e74bb1769b03d1b377a5ca5a73154b42a55665a45d98255f298af95b9939bee" => :yosemite
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-libiconv", "Build with brewed libiconv. Dcmtk and system libiconv can have problems with utf8."
  option "with-dicomdict", "Build with baked-in DICOM data dictionary."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl" => :recommended
  depends_on "libiconv" => :optional

  def install
    args = std_cmake_args
    args << "-DDCMTK_WITH_OPENSSL=NO" if build.without? "openssl"
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
    args << "-DDCMTK_ENABLE_BUILTIN_DICTIONARY=YES -DDCMTK_ENABLE_EXTERNAL_DICTIONARY=NO" if build.with? "dicomdict"
    args << "-DDCMTK_WITH_ICONV=YES -DLIBICONV_DIR=#{Formula["libiconv"].opt_prefix}" if build.with? "libiconv"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make", "DOXYGEN" if build.with? "docs"
      system "make", "install"
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
