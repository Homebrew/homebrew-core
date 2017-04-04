class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.3.4/fuse-1.3.4.tar.gz"
  sha256 "3089d2c3e08c72055ccbcbd5bcc69fd6cc492b8ac649ee15fc93703f0d3d9486"

  bottle do
    sha256 "8612c1dd8bda0158b034bc8add94d96291f0cbeccb93c612dd7efa1a6c748e0c" => :sierra
    sha256 "b03b946fb539111c98f8a11681f22b3bc5b0cd7004dd272012480ecfe6cfecd9" => :el_capitan
    sha256 "cac10b231831430ebf375e483781e2a6f25533e8060c34f2a9ff55795b42c0f0" => :yosemite
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
