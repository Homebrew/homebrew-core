class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.1/libjpeg-turbo-1.5.1.tar.gz"
  sha256 "41429d3d253017433f66e3d472b8c7d998491d2f41caa7306b8d9a6f2a2c666c"

  bottle do
    cellar :any
    sha256 "ec7e1209ccd099e1ce0a68441c7ed0ef92daa0fcfc6cd7b558100548ff1b3e4a" => :sierra
    sha256 "1e026d7d465357247205ea729eba197732f7331134c0ee90518b946cfd2824e7" => :el_capitan
    sha256 "c308fdae60dee53418f95689b42ecf2d5517bdcf195a03f5db4f0d938c45e913" => :yosemite
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-jpeg8
      --mandir=#{man}
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    ENV.deparallelize # Stops a race condition error: file exists
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-perfect",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
