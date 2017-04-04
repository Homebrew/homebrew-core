class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.7.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7.orig.tar.gz"
  sha256 "9f43a2cfb9589e5cecaa66e16bf87f814c945f22df7ba600d63aac4632c4f019"
  revision 2

  bottle do
    cellar :any
    sha256 "c2212960a740a559d42c2d150a7f0fedd191c1b2b2ff0b815e54299ccc8ebe29" => :sierra
    sha256 "8e75bf8bcd907c19a56ca7f83f0d29b6651f31a85fb1b2bccc72e5b4ec6337c2" => :el_capitan
    sha256 "3d22664e9f1c12b123913bcba3306fe922a860c2399fd33e778f86f58ffe6151" => :yosemite
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Patches from Debian for CVE-2016-10094, and various other issues.
  # All reported upstream, so should be safe to remove this block on next stable.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7-5.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.7-5.debian.tar.xz"
    sha256 "f4183c48ed74b6c3c3a74ff1f10f0cf972d3dba0f840cf28b5a3f3846ceb2be6"
    apply "patches/01-CVE.patch",
          "patches/02-CVE.patch",
          "patches/03-CVE.patch",
          "patches/04-CVE.patch",
          "patches/05-CVE.patch",
          "patches/06-CVE.patch",
          "patches/07-CVE.patch",
          "patches/08-CVE.patch",
          "patches/09-CVE.patch",
          "patches/10-CVE.patch",
          "patches/11-CVE.patch",
          "patches/12-CVE.patch",
          "patches/13-CVE.patch",
          "patches/14-CVE.patch",
          "patches/15-TIFFFaxTabEnt_bugfix.patch",
          "patches/16-CVE-2016-10094.patch",
          "patches/17-CVE-2017-5225.patch"
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
