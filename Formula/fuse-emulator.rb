class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.3/fuse-1.5.3.tar.gz"
  sha256 "c83972381ae3bf105abe8a8ef9da94e4599560ed0d63d5ac5c7b81a72eb0aa04"

  bottle do
    sha256 "48e80f0811b93b75de1fad0a3b1c9184a1cbd4635e9db0638c02b51ef8a08a16" => :high_sierra
    sha256 "795b23cbc22c98ecf3afc12d7c1111cd5f2e10e0e025d1ceedfa4ac35d249bf7" => :sierra
    sha256 "a4cd0a67c0412e8ff9bfcd358083a50a7c5ae8ed76d751aaeb871fbcea338146" => :el_capitan
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
