class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz"
  sha256 "73aea623930c7d18a7a778eea391e1ddfbe90ad1ac40a91b380afca4b0e1dab8"

  bottle do
    cellar :any
    sha256 "f60860b5f508bb3a2e1123745e48de6ac4cc2e10864c8a7438c57458122e3407" => :catalina
    sha256 "795d7fce11f480361f5112d4fc63c7d091e97071edca114287eb0b06218426a9" => :mojave
    sha256 "af7016b2d60ca7dd02d91287994633b2674436587464e824294dc930566ffef1" => :high_sierra
    sha256 "837b44e4c36513df3d615d02ce986119049e1188c975343476d84380e43b0a19" => :sierra
    sha256 "a853675774b68249fd1aedc56a7c796fbc3177f7b64fbff666d21efd4c711611" => :el_capitan
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

  def caveats; <<~EOS
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
