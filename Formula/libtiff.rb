class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.7.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7.orig.tar.gz"
  sha256 "9f43a2cfb9589e5cecaa66e16bf87f814c945f22df7ba600d63aac4632c4f019"
  revision 3

  bottle do
    cellar :any
    sha256 "02c864665601d8877cc6a3ab3128f3881179fce30a0b4759889785e625510e22" => :sierra
    sha256 "15d450ae98bf8641f6007b14b9dffe1966684c929bc001ce81549acabc9c65df" => :el_capitan
    sha256 "a08754ba33e157e809a9fd8224f286e42d697818e82cd13c360842b806aefaa4" => :yosemite
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Patches from Debian for CVE-2016-10094, and various other issues.
  # All reported upstream, so should be safe to remove this block on next stable.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7-6.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.7-6.debian.tar.xz"
    sha256 "9c9048c28205bdbeb5ba36c7a194d0cd604bd137c70961607bfc8a079be5fa31"
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
          "patches/17-CVE-2017-5225.patch",
          "patches/18-CVE-2017-7595.patch",
          "patches/19-CVE-2017-7598.patch",
          "patches/20-CVE-2017-7596_CVE-2017-7597_CVE-2017-7599_CVE-2017-7600.patch",
          "patches/21-CVE-2017-7601.patch",
          "patches/22-CVE-2017-7602.patch",
          "patches/23-CVE-2017-7592.patch",
          "patches/24-CVE-2017-7593.patch",
          "patches/25-CVE-2017-7594_part1.patch",
          "patches/26-CVE-2017-7594_part2.patch"
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
