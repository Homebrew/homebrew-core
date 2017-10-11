class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.4.1/fuse-1.4.1.tar.gz"
  sha256 "817d57db6da95a411b5b44ccae2a00fff332b251b502957a8a886d794d475aa3"

  bottle do
    sha256 "60785a91bb0f2d50fe18ceaaa999270dfa60b5495d25ba49d6adbefd3916df65" => :high_sierra
    sha256 "4a8a45aca60a1d609ac31be33b2839cb51cd9479a0b21ea7884de3316428f4b8" => :sierra
    sha256 "0351ab9d121e21610179d065ce076c45973ffe151decbd3814ba1e16eaffd0d0" => :el_capitan
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
