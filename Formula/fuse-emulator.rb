class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.0/fuse-1.5.0.tar.gz"
  sha256 "b1134a9f4d211cf9dbf845dd5b28a4a58a4ab69f3bf1f7d04d1c26147e0daefd"

  bottle do
    sha256 "0b09770a4025acb0491f7ab56370102a6de83a221a46a491405670c33da2f00b" => :high_sierra
    sha256 "bbdffa604fc85313d841e78ffcbd132602cec00d1663bf0dfe7dbe8bb8656155" => :sierra
    sha256 "7a7cc42459ecc43e925877a4bbf586f9e0023e32d3c7eff9c00fb08fefccdad7" => :el_capitan
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
