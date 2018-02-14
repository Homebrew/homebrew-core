class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"
  url "http://dicom.offis.de/download/dcmtk/dcmtk363/dcmtk-3.6.3.tar.gz"
  sha256 "63c373929f610653f10cbb8218ec643804eec6f842d3889d2b46a227da1ed530"
  head "http://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "ebc1492ba0b008c2d84e84cce1be2da9eb9210ffa8809bcfc710a0bcf35d5575" => :high_sierra
    sha256 "c7771b2deb50e919f2b332d532f7f81bd67331a2350aea85f7f61658a70b5b15" => :sierra
    sha256 "586903834cdc7bbc4ffc7adb5478b63fb80df1f95b1a631a8b41d5b54bbc275f" => :el_capitan
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
