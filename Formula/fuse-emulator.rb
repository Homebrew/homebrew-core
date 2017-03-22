class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.3.4/fuse-1.3.4.tar.gz"
  sha256 "3089d2c3e08c72055ccbcbd5bcc69fd6cc492b8ac649ee15fc93703f0d3d9486"

  bottle do
    sha256 "70f1a05abd9802909c85062bbddca4d3f0171a214b454b56b171b38ef1929c65" => :sierra
    sha256 "1360159ea0bb838de0cec3782a6af28ded4c59153138f8c2edcb36ee2a9bb862" => :el_capitan
    sha256 "eda6b8de1c0be710b5b2627471ab41c2b553dd5c2f0bcd6bccede749d50c40c8" => :yosemite
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
