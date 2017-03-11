class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.3.3/fuse-1.3.3.tar.gz"
  sha256 "670184600230dd815b2c26d701ec035ba0f7a063c44b5480cab01eb9926a494e"

  bottle do
    sha256 "64737eb8111050993cb5b8995f285ce018141f2f7be079023561c2c4df7d584b" => :sierra
    sha256 "c55810145c5bb324d9c077aa5965fe7aab4a12ca8c3c8f2f64228c51dd0ed71f" => :el_capitan
    sha256 "8faa66fe11bb79a04ec83a811eb26dd1f496bd43f652271e6ccb690b78e031d1" => :yosemite
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
