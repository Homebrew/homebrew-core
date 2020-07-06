class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/3.0.1/chocolate-doom-3.0.1.tar.gz"
  sha256 "d435d6177423491d60be706da9f07d3ab4fabf3e077ec2a3fc216e394fcfc8c7"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "91f8a622d0299afd99d6eb4768184100addb0d1a804683aa6486548ed5a14d8d" => :catalina
    sha256 "9090cd83e434977b523647ea125b5de78ca8c2b434f1933a606200999e137a30" => :mojave
    sha256 "c4799300dc6c4b10d68e0764cb57eec612fbe3d07a2ce7eeb0cf6bc60905a687" => :high_sierra
  end

  head do
    url "https://github.com/chocolate-doom/chocolate-doom.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

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

  def caveats
    <<~EOS
      Note that this formula only installs a Doom game engine, and no
      actual levels. The original Doom levels are still under copyright,
      so you can copy them over and play them if you already own them.
      Otherwise, there are tons of free levels available online.
      Try starting here:
        #{homepage}
    EOS
  end

  test do
    assert_match "Chocolate Doom #{version}", shell_output("#{bin}/chocolate-doom -nogui", 255)
  end
end
