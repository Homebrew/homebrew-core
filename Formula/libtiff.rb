class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.8.tar.gz"
  sha256 "59d7a5a8ccd92059913f246877db95a2918e6c04fb9d43fd74e5c3390dac2910"
  revision 5

  bottle do
    cellar :any
    sha256 "62c0b911f0e0e0e999d6362088888c754422de923f450b8d718b9bf9ec353f57" => :high_sierra
    sha256 "b47df6ebeef991de9a33768c646677e26c447c2838b59aaae4e4e701d808e87f" => :sierra
    sha256 "1a6b89cb8cc27e38d178799ec56498447fd74a9b758428149b103f41b6005b0b" => :el_capitan
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # All of these have been reported upstream & should
  # be fixed in the next release, but please check.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.8-6.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.8-6.debian.tar.xz"
    sha256 "9307f5343882fa0d8229d20f35cd03cf113dc88881bf697b0ee2b3969ffdbe72"
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
          "patches/11-CVE-2017-13727.patch",
          "patches/12-prevent_OOM_in_gtTileContig.patch",
          "patches/13-prevent_OOP_in_TIFFFetchStripThing.patch",
          "patches/14-CVE-2017-12944.patch",
          "patches/15-avoid_floating_point_division_by_zero_in_initCIELabConversion.patch"
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
