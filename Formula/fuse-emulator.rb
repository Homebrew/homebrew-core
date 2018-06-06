class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.4/fuse-1.5.4.tar.gz"
  sha256 "3d40f2e7374f5a3d5a40ce2e91912b1c064b33de8831d5979ec2b89a8e69abf3"

  bottle do
    sha256 "18d71cebf0b62bfaac50617afcebd2a2412a02356c06aec8eee58c410e42cff8" => :high_sierra
    sha256 "b2587394de6205e0b0a3628357d282a3b6211cf96408b1542cb77b0a106cd361" => :sierra
    sha256 "88176fe4db0280ab3f1e153cd012f2213196fd33a81ca31dc2d920c145bcae18" => :el_capitan
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
