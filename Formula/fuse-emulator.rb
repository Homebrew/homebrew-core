class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.4.1/fuse-1.4.1.tar.gz"
  sha256 "817d57db6da95a411b5b44ccae2a00fff332b251b502957a8a886d794d475aa3"

  bottle do
    sha256 "de6e7b0aecc2f5fc306ab4b646fd38b64371bf3a834bf68dee959a443e38221b" => :high_sierra
    sha256 "f48633892f33176cd6ee9c9c2b430283fae9c6c23f4daf1cded2c95c1c3dcfe2" => :sierra
    sha256 "4a54fba8bb31b603d7496416d8b37f2be12cb7b2c56a022cd67224c9c1d88292" => :el_capitan
    sha256 "270841c1a593c468409e05df66e31af51ffb4278ffa7e4b07a8864bb0c22e5bb" => :yosemite
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
