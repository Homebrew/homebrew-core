class NeopopSdl < Formula
  desc "NeoGeo Pocket emulator"
  homepage "https://nih.at/NeoPop-SDL/"
  url "https://nih.at/NeoPop-SDL/NeoPop-SDL-0.2.tar.bz2"
  sha256 "2df1b717faab9e7cb597fab834dc80910280d8abf913aa8b0dcfae90f472352e"

  bottle do
    cellar :any
    sha256 "3d8a1f106136142a38f8ec89e0bd2403d6294f51ba86211a1309e58186906f50" => :sierra
    sha256 "6b56cf6822ca345a48cca6527417f449d884b35bde617b9d59058b1e29a2b7e4" => :el_capitan
    sha256 "3eb50b57fef442f83df0d9d92f1612094a40feb38658b9d153eae568d0570472" => :yosemite
  end

  head do
    url "http://hg.nih.at/NeoPop-SDL/", :using => :hg
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
