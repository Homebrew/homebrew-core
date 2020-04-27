class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/easyrpg-player-0.6.2.tar.xz"
  sha256 "3550200c4b7c42fa7bd5774de5016b48d5660cc33d1614f174f474702ee253b9"

  bottle do
    cellar :any
    sha256 "97a6be8f5e6f2c7b782bdbbe92a49a59ac9ad27119dc6b248e7ceb99db5fcfa5" => :catalina
    sha256 "ce83ff05744c75fb5fcbcf681e8e163c8460b778debff28f54422892c970306a" => :mojave
    sha256 "c2dd612a8529a42cc46166728c96fb1430cb3d00e23ce7d9c5fe5e8df999b78d" => :high_sierra
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
