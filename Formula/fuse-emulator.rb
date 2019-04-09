class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.6/fuse-1.5.6.tar.gz"
  sha256 "cb0e1f8e7c15a57710bcd7a844bd954134d28f169870c3633f59fa32bfc38037"

  bottle do
    sha256 "14935f8f3bc815e698bf446fb107bb90ef2fb31150118b4331ce01c3979eb3be" => :mojave
    sha256 "ffda96ce6f016a11c0ec1290757d86c3f37e5bdd7a7df9be2a1d95ec824879fb" => :high_sierra
    sha256 "b73ceeae42b9123f45a4a11912b66a9bc543382103cdaf76711e43681243783b" => :sierra
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
