class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.8.tar.gz"
  sha256 "59d7a5a8ccd92059913f246877db95a2918e6c04fb9d43fd74e5c3390dac2910"
  revision 1

  bottle do
    cellar :any
    sha256 "05816933252a551b69ef2999fd735a17c495790ef42b7a31d15b285209f0e22d" => :sierra
    sha256 "074c6ddeac411817ddd1a4a59b0e6fc4ada76b90ea3c51ee8d8ef4e9e79e2522" => :el_capitan
    sha256 "81e3b47d910e516005520fdece47dcf03b71494cf06f9a2016ed151ff016c518" => :yosemite
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # All of these have been reported upstream & should
  # be fixed in the next release, but please check.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.8-3.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.8-3.debian.tar.xz"
    sha256 "8803ef2917ceb80c472e97d85e86f71a20d04cf7de94ebffcc1b3100f51058ce"
    apply "patches/01-CVE-2015-7554.patch",
          "patches/02-CVE.patch",
          "patches/03-CVE.patch",
          "patches/04-CVE-2016-10095_CVE-2017-9147.patch",
          "patches/05-CVE-2017-9936.patch",
          "patches/06-OOM_in_gtTileContig.patch",
          "patches/07-CVE-2017-10688.patch"
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
