class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"
  url "http://dicom.offis.de/download/dcmtk/dcmtk363/dcmtk-3.6.3.tar.gz"
  sha256 "63c373929f610653f10cbb8218ec643804eec6f842d3889d2b46a227da1ed530"
  head "http://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "9b328afaa927a5001da453c3020ce895e2456c532289dd09b7a570a7517c54df" => :high_sierra
    sha256 "667469116e8e934360205c525fc3cf30290e64f44bc99ee85adf516dfcb39298" => :sierra
    sha256 "b245dc0c76c6075b9756a16ff50337b4fdfe33ded46c788f19925635c09344b2" => :el_capitan
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
