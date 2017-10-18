class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.8.tar.gz"
  sha256 "59d7a5a8ccd92059913f246877db95a2918e6c04fb9d43fd74e5c3390dac2910"
  revision 4

  bottle do
    cellar :any
    sha256 "4fefeed096469cbcaa2a5708900155d5d19b51f877c18d5545e7fda83048af74" => :high_sierra
    sha256 "31d87d01ab80f662899a09efa2eb517689fc758a31f1170c1ea2448d098291c2" => :sierra
    sha256 "6b2c64b6e251707fb8fc3dee0b947a8108432e1ef73fa7e8c3983596a2fd0649" => :el_capitan
    sha256 "855c2d44ad08e24f9748857b6f351f674b682bb16664c2da3f24c29223eb4657" => :yosemite
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # All of these have been reported upstream & should
  # be fixed in the next release, but please check.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.8-5.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.8-5.debian.tar.xz"
    sha256 "0a72efaba5da935537dd7dc28593503c3a0161d954fcd2da6eb511c0238d1387"
    apply "patches/01-CVE-2015-7554.patch",
          "patches/02-CVE.patch",
          "patches/03-CVE.patch",
          "patches/04-CVE-2016-10095_CVE-2017-9147.patch",
          "patches/05-CVE-2017-9936.patch",
          "patches/06-OOM_in_gtTileContig.patch",
          "patches/07-CVE-2017-10688.patch",
          "patches/08-LZW_compression_regression.patch",
          "patches/09-CVE-2017-11335.patch",
          "patches/10-CVE-2017-13726.patch",
          "patches/11-CVE-2017-13727.patch"
  end

  def install
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
    (testpath/"test.c").write <<~EOS
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
