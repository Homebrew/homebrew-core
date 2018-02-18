class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz"
  sha256 "73aea623930c7d18a7a778eea391e1ddfbe90ad1ac40a91b380afca4b0e1dab8"

  bottle do
    cellar :any
    sha256 "a7938d0bfbe6e213a7ca0c464e867ce491015a0862fbda46858ca0ede1b6d41f" => :high_sierra
    sha256 "b0573351b617c4947aa6865119add2521c779adf1afbc7f9e3af476f46f25315" => :sierra
    sha256 "c9cb2efe87e1f7ab038198506d07eb306059cef3b13e8022c7442901a6516a34" => :el_capitan
    sha256 "eec9121c06d749dfa8a7b53784e9570d1ff3c0c1f0e69a47b30de2290fc777dc" => :yosemite
  end

  head do
    url "https://github.com/chocolate-doom/chocolate-doom.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"
  depends_on "sdl2_mixer"
  depends_on "libsamplerate" => :recommended
  depends_on "libpng" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sdltest"
    system "make", "install", "execgamesdir=#{bin}"
    (share/"applications").rmtree
    (share/"icons").rmtree
  end

  def caveats; <<~EOS
    Note that this formula only installs a Doom game engine, and no
    actual levels. The original Doom levels are still under copyright,
    so you can copy them over and play them if you already own them.
    Otherwise, there are tons of free levels available online.
    Try starting here:
      #{homepage}
    EOS
  end
end
