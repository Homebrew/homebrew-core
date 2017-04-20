class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/Player/archive/0.5.1.tar.gz"
  sha256 "d93c092c38a8af81099b99645e15f0189ff2ffc0552cb2094ecb6c337f219b7c"
  head "https://github.com/EasyRPG/Player.git"

  bottle do
    cellar :any
    sha256 "4faa5ec91fd1bc21e827b8551a560186a440f47eff9fbeaf59ea51544068e41f" => :sierra
    sha256 "7935f6766acc63d0da50243d4a83f91d3b6ed16f22e36162b8ed252839850217" => :el_capitan
    sha256 "24667d520ace7c0953a06fab122c46ae64223122c5135a4b5a334c8670cbaff5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "sdl2_mixer" => "with-libvorbis"
  depends_on "speex"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v")
  end
end
