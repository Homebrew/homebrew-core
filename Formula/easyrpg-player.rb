class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/Player/archive/0.5.0.tar.gz"
  sha256 "5cf8cf5c4383b2b9c28c8dbbf15ccef601b1c66af30f783c41b98c06a8a61977"
  head "https://github.com/EasyRPG/Player.git"

  bottle do
    cellar :any
    sha256 "036dfeb49ca0827e14ff4c1c96b726f15bc9be592f6a38d7e1fab1856e25f124" => :sierra
    sha256 "0186b14b1cb003d83b0d0936608f0f612317e407294e0609ac9c91593942d222" => :el_capitan
    sha256 "57aeeba707926c3ac097eaa867e55f9b777ec8782523b00443429e8ea0d6971a" => :yosemite
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
