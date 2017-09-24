class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/easyrpg-player-0.5.2.tar.gz"
  sha256 "3ede43b0bbcd72103507d1f076810506b03d374b481dfe41c9f733bb21cddd24"

  bottle do
    cellar :any
    sha256 "78fe4b10be3cb8c0f8183f4335a1a860bd0ce23e3c8337603a66ba4ba8d1f914" => :high_sierra
    sha256 "7c47cb423692e6f4ecf81e99396052e29d504cebb862044f10376a4ffeae5f15" => :sierra
    sha256 "d4940a4c8cd7e3b16a8598daf90085d382b05cff86cf4e9c4882dec5b38c97fa" => :el_capitan
    sha256 "cc9a7616f69ca42722b9a169cf20be92368c47033948951aa6422637d2824541" => :yosemite
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
