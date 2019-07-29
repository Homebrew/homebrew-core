class NeopopSdl < Formula
  desc "NeoGeo Pocket emulator"
  homepage "https://nih.at/NeoPop-SDL/"
  url "https://nih.at/NeoPop-SDL/NeoPop-SDL-0.2.tar.bz2"
  sha256 "2df1b717faab9e7cb597fab834dc80910280d8abf913aa8b0dcfae90f472352e"

  bottle do
    cellar :any
    sha256 "d84d1d9e2304a21ce915b8a65001a310da3c797e1f89e4d8a86a102e53f92f10" => :mojave
    sha256 "9bdf06235151ae52d85e630021ce810d49ce12ba74e18b27f7584d9584377eb4" => :high_sierra
    sha256 "3510d31984f2f46a59390617e2af3941638a4eb20a42131fc804e5d307cb5059" => :sierra
    sha256 "e115fe849a0b8e1921a6c36c3d34fcc00b911f0504a0e32543656e76513384ad" => :el_capitan
    sha256 "a8de30162f9e5146ee7c39480e83588f8036c0b965215e7ce1894c79855c8687" => :yosemite
  end

  head do
    url "https://hg.nih.at/NeoPop-SDL/", :using => :hg
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "ffmpeg"
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_equal "NeoPop (SDL) v0.71 (SDL-Version #{version})", shell_output("#{bin}/NeoPop-SDL -V").chomp
  end
end
