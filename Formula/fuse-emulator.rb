class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.7/fuse-1.5.7.tar.gz"
  sha256 "f0e2583f2642cdc3b2a737910d24e289d46e4f7e151805e3b0827024b2b45e4d"

  bottle do
    sha256 "53310374faf051b906a38e8cabac72c9b68d1c671f1c33161dee0e4b44263e16" => :mojave
    sha256 "007c73a4b5bd3a79b3fa49683e12672afdcc6456d0d89c53de672ec308741555" => :high_sierra
    sha256 "f61e728e1a3bd5c89e8f9f887f15d5d18ab37cc0af6a857547eff7314d297305" => :sierra
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
