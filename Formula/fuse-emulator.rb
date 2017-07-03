class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.3.6/fuse-1.3.6.tar.gz"
  sha256 "184a91f1320cf81cafeea1a7e4cb0e76ca43bcf6060f8d20b0bfb98790eadd35"

  bottle do
    sha256 "d9d2a2529272fe8570e420fcc4712c82a1dd9b9fb843946943cf75fb008bd437" => :sierra
    sha256 "c19e42339bd566effcad99e11071e0290d41bc328b144d3507f6640fb4a6678d" => :el_capitan
    sha256 "827fd35ecc1eff3e069cf3e1525fec6c17c984513eb7c024d3f66f1bcf29cf68" => :yosemite
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
