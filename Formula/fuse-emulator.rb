class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "http://fuse-emulator.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.3.2/fuse-1.3.2.tar.gz"
  sha256 "576bf916b499a4d5932acc34d315e2acd36636d1d5a3911c839589487a6b68e6"

  bottle do
    sha256 "50f40554c9c5b2ac2ea8fa9a3921951953f34b6f701cade4e30c0a4a48d1ca97" => :sierra
    sha256 "0ab8a31e1b8d350b96656ee105c2eca3ce60116f86e75c293eb3f2c6c3b35fce" => :el_capitan
    sha256 "360cbef5b242257abe2885b77a39f49e7fa5cab45b9e94582107535f45a377ba" => :yosemite
  end

  head do
    url "http://svn.code.sf.net/p/fuse-emulator/code/trunk/fuse"
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
