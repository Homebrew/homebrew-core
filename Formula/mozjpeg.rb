class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/releases/download/v3.1/mozjpeg-3.1-release-source.tar.gz"
  sha256 "deedd88342c5da219f0047d9a290cd58eebe1b7a513564fcd8ebc49670077a1f"
  revision 1

  # Fix crashes in ASM code with current llvm/clang versions.
  # See https://github.com/libjpeg-turbo/libjpeg-turbo/pull/20
  # and https://github.com/mozilla/mozjpeg/issues/202 for info.
  patch do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo/pull/20.patch"
    sha256 "d29a4b48fff3d3f22d1281f4125ff2bdf84eb25819facd724a8096ae04e6cd94"
  end

  # Fix negative shift with IFAST FDCT and qual=100
  # Patch from freebsd/freebsd-ports based on commit:
  # https://github.com/libjpeg-turbo/libjpeg-turbo/commit/4cfa3f4
  # See https://github.com/mozilla/mozjpeg/pull/186 for info.
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/a608b6f56cca57cebe410682434706e8a45d548e/graphics/mozjpeg/files/patch-jcdctmgr.c"
    sha256 "1b94aac7d0e4dcadc9dae1dc33607faa468f0de3c4f07c8f918de64a54478253"
  end

  bottle do
    cellar :any
    sha256 "ad93e6e201c134282c5c637dfddf127670034d7c0d854ab3e980f8589aa29da2" => :el_capitan
    sha256 "3357079063037751fcd9698ee9980368ddbdb2bb3d9770d3767d3a76e6838148" => :yosemite
    sha256 "1d779644f67e48436476fd7a6849b63db2805da812f28e02ccec0219ade8f052" => :mavericks
  end

  head do
    url "https://github.com/mozilla/mozjpeg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  depends_on "pkg-config" => :build
  depends_on "nasm" => :build
  depends_on "libpng" => :optional

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-optimize",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
