class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.7/fuse-1.5.7.tar.gz"
  sha256 "f0e2583f2642cdc3b2a737910d24e289d46e4f7e151805e3b0827024b2b45e4d"

  bottle do
    sha256 "02077e1c85ad805fee01eb56b64d40aabdcb6775609bfcaa699379ebde518c5a" => :mojave
    sha256 "174a632d3c5a39ac6d38d523cef15c3e347ac14cb86cfc8012ec6da4a9995f87" => :high_sierra
    sha256 "1ed61593da9edd09821668053fc236cfeb130fe2e1b00fb38b36f2677f90c496" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/fuse"
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
