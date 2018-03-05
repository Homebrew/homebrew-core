class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.1/fuse-1.5.1.tar.gz"
  sha256 "5e99a67776e39534130235cb79d23d7678c44f39a864d157fdc5c4063291bd3c"

  bottle do
    sha256 "c484a593e10bc3a8fc1d466558dff2f7151deeeeab5fca6be157e038fc0f7c2d" => :high_sierra
    sha256 "89caf335f2e92cabee257ae393c19014528cc4bf022a16f7a6af7241ac535067" => :sierra
    sha256 "88808eb47ab7b776552e3b2f8adc8c147d0e6d8e389eef6abf296dbc6bd2f7dd" => :el_capitan
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
