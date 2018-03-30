class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.2/fuse-1.5.2.tar.gz"
  sha256 "141550e2ed270d800307333b1e3d588ab75d92522434cf82948755eb38ffbd5a"

  bottle do
    sha256 "31b2c28e12d90ad3dc15c10696fbe648a91c1dded6fd7f746b9b882bd6b8b425" => :high_sierra
    sha256 "9f1bd4787ea78b08319bf4cb10c8e299f4a8d5545b03586d2a83ed24d53a693c" => :sierra
    sha256 "e10900677ab6b271c93020a79440173eeb88972e512fd0edf1ea91fc5955bc82" => :el_capitan
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/fuse"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "libspectrum"
  depends_on "libpng"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-sdl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fuse", "--version"
  end
end
