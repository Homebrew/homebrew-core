class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/easyrpg-player-0.5.3.tar.gz"
  sha256 "abd26ed487618780a3675869517fc52d63ad8019c3a87c5aaeefce64c464f83d"

  bottle do
    cellar :any
    sha256 "421d0a53990b0f35034a0ad6ab4b8f5fcc5ebebe54f96d2cfcb85aa910955c16" => :high_sierra
    sha256 "2d63d22e5653c2512738b7548421767f4f196fad161b7cf75c16c810c541c1cd" => :sierra
    sha256 "a3bdeadf11643d89283a7721ea1cb0d0534fd27aa2be036d0a04df87768d9ea1" => :el_capitan
  end

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
  depends_on "sdl2_mixer"
  depends_on "speexdsp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v")
  end
end
