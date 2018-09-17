class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.5/fuse-1.5.5.tar.gz"
  sha256 "bd0e58bd5a09444d79891da0971f9a84aa5670dd8018ac2b56f69e42ebda584e"

  bottle do
    sha256 "4b31387b1dccb1fbf5e9cb16b6a2005a8d671ad41e21bd4a3619e981e7cb1dd8" => :mojave
    sha256 "962a47d502bfeea1e2d10f4a4f287a658c3c0e2362b85b992810ee32ee7adb9f" => :high_sierra
    sha256 "eb4bd91ef6dab28436830cada55c85f7834b722a207f43694d944819a6346c56" => :sierra
    sha256 "b3092d601e7da78aadc43dcb3e1c1b32fddd478458e44e689d486d2537b505c6" => :el_capitan
  end

  head do
    url "http://svn.code.sf.net/p/fuse-emulator/code/trunk/fuse"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libspectrum"
  depends_on "sdl"

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
