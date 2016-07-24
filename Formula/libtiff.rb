class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://www.remotesensing.org/libtiff/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz"
  mirror "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.6.tar.gz"
  sha256 "4d57a50907b510e3049a4bba0d7888930fdfc16ce49f1bf693e5b6247370d68c"
  revision 2

  bottle do
    cellar :any
    sha256 "c2b56ccd774d9f4eac5b393a4300865eee7ee64966386ac7afcced5873dbd696" => :el_capitan
    sha256 "b5f28d94e804aae4102bb7d319f9e51e00fcec180c21c71e0dac7f78031f2f58" => :yosemite
    sha256 "85e241a4f95aa755759570647723031f0fe12805a32ffe7504174351a96147b2" => :mavericks
  end

  option :universal
  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Backports of various security/potential security fixes from Debian.
  # Already applied upstream in CVS but no new release yet.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.6-2.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.6-2.debian.tar.xz"
    sha256 "82a0ef3f713d2a22d40b9be71fd121b9136657d313ae6b76b51430302a7b9f8b"
    apply "patches/01-CVE-2015-8665_and_CVE-2015-8683.patch",
          "patches/02-fix_potential_out-of-bound_writes_in_decode_functions.patch",
          "patches/03-fix_potential_out-of-bound_write_in_NeXTDecode.patch",
          "patches/04-CVE-2016-5314_CVE-2016-5316_CVE-2016-5320_CVE-2016-5875.patch",
          "patches/05-CVE-2016-6223.patch",
          "patches/06-CVE-2016-5321.patch",
          "patches/07-CVE-2016-5323.patch"
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
    ]
    if build.with? "xz"
      args << "--with-lzma-include-dir=#{Formula["xz"].opt_include}"
      args << "--with-lzma-lib-dir=#{Formula["xz"].opt_lib}"
    else
      args << "--disable-lzma"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
