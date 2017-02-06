class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "http://www.chocolate-doom.org/"
  url "http://www.chocolate-doom.org/downloads/2.2.1/chocolate-doom-2.2.1.tar.gz"
  sha256 "ad11e2871667c6fa0658abf2dcba0cd9b26fbd651ee8df55adfdc18ad8fd674a"

  bottle do
    cellar :any
    revision 1
    sha256 "1672f5f2388e3fb0a5c9541b645090d27aaef07c9b6de516e64bd63c86f0b635" => :el_capitan
    sha256 "219a149ac91fcefdbecffec5ee8d2164453dbd7b03674b6aa279b700203b21ba" => :yosemite
    sha256 "6a6b0e67cd0be2f3476dd16ff6e6cb8e2b702a212f979048999f5a4c0d2c929e" => :mavericks
  end

  head do
    url "https://github.com/chocolate-doom/chocolate-doom.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_mixer"
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

  def caveats; <<-EOS.undent
    Note that this formula only installs a Doom game engine, and no
    actual levels. The original Doom levels are still under copyright,
    so you can copy them over and play them if you already own them.
    Otherwise, there are tons of free levels available online.
    Try starting here:
      #{homepage}
    EOS
  end
end
