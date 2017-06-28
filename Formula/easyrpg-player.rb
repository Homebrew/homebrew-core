class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/easyrpg-player-0.5.2.tar.gz"
  sha256 "3ede43b0bbcd72103507d1f076810506b03d374b481dfe41c9f733bb21cddd24"

  bottle do
    cellar :any
    sha256 "e8eaa8f75f3f56592bcfaf10f38f628e142574d9df3d1a01180d5c22f5c7eb7c" => :sierra
    sha256 "584781c2929c14f1153e87fc28068d1e006fc629f2caef59ff1e847e343cf675" => :el_capitan
    sha256 "fba0e66131648a46ea3a1accff15dec77e7ecf57e557263218d2584cc76b0a4a" => :yosemite
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
  depends_on "speex"

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
