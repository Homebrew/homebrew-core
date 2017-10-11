class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"
  url "http://dicom.offis.de/download/dcmtk/dcmtk362/dcmtk-3.6.2.tar.gz"
  sha256 "1b5cf1dcb23cad401310c3afeb961c3613e3d20ab2d161dcc8bf0735b443218d"
  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "b900c5ddef45596eb7d51b5bc4c504595c25acd011b7627b9c54282187c3130b" => :high_sierra
    sha256 "c16eed98ab93d05889a73c2f8ced0528f79e18bd2b2f6ffd614b3783c2799559" => :sierra
    sha256 "4f108d543ab8301041dbb39f1cae4db40d794acf52dc682d1c090ee98b9bec45" => :el_capitan
    sha256 "bd2ccb04c0f419299ecece817e4d46da7b8cbe5b1636ee25c460fc628d55ea13" => :yosemite
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
