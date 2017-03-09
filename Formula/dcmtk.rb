class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now.
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20170228.tar.gz"
  version "3.6.1_20170228"
  sha256 "8de2f2ae70f71455288ec85c96a2579391300c7462f69a4a6398e9ec51779c11"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "d2f1b4cde8c9469ee42bf9271b20a305ea75eb59632d37b408aa9900c54b3485" => :sierra
    sha256 "04082c805dfc1d504e8bfd02f24be60c79fb39e365c17e95aea8a5815a4b9713" => :el_capitan
    sha256 "96dccd681ab37da2898afa3ee9c2aa03d11b7451b936f25ca5f56d5c797ba5d6" => :yosemite
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-libiconv", "Build with brewed libiconv. Dcmtk and system libiconv can have problems with utf8."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << "-DDCMTK_WITH_OPENSSL=YES"
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
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
