class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now.
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20161102.tar.gz"
  version "3.6.1-20161102"
  sha256 "657adb3811e0c5c08d8f143a6d878afcd92fac7dcf0d3c89860eecffd5a1a873"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "37e5e4810a31bf116d40897213822ec7d9a95c396ff5cb59ddadfcd1d3b07bd8" => :sierra
    sha256 "15225b3069a9351225b6950b31f85869a12f733b9e4b23958d950b2fd6e81b21" => :el_capitan
    sha256 "f706fdffaf47aa1506d2f7fd0e1988c049c16ab1f310f0fbcd77937c9483348b" => :yosemite
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
