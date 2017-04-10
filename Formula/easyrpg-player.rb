class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/Player/archive/0.5.1.tar.gz"
  sha256 "d93c092c38a8af81099b99645e15f0189ff2ffc0552cb2094ecb6c337f219b7c"
  head "https://github.com/EasyRPG/Player.git"

  bottle do
    cellar :any
    sha256 "8f8493333de08e5f1de487f3784e17b848e8e7586a718f7491f3453416bd4645" => :sierra
    sha256 "7a0c1e3f3661bc23da6245c959b3a4d2c868a1d960bc0e37d108ea3950bf0ae7" => :el_capitan
    sha256 "58c994b0554116c0222fb94f2e0809db3dc5c44e4cff909c9ef7de0310185ca7" => :yosemite
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
