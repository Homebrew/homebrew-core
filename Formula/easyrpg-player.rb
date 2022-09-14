class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/easyrpg-player-0.7.0.tar.xz"
  sha256 "12149f89cc84f3a7f1b412023296cf42041f314d73f683bc6775e7274a1c9fbc"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "71895da3ee0ae93fff96e9dba48afa5609c4b2d2b42102a862da4673605e366c"
    sha256 cellar: :any,                 arm64_big_sur:  "7fd2cb62de865ab95efc459f40961ac22226f1734ba59f1b9b0317bbd38be072"
    sha256 cellar: :any,                 monterey:       "7d663c0d68fbaca66bfdaa49f8d20c96ad28806193e0c76c0a28225b6999212a"
    sha256 cellar: :any,                 big_sur:        "8b3ce92dc8aa8cccbbfdc395c523d2e9309a64d0073fe7c12488d3abc9f7e308"
    sha256 cellar: :any,                 catalina:       "a0ab488ffe50144343477885b1b76d0a17976c410087600848e664b46cd9458c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4dcac0b158f6af96b65178da115aaa8dbed80b0912d47039eb89e5d1daf7e8"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/EasyRPG Player.app"
      bin.write_exec_script "#{prefix}/EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv "#{bin}/EasyRPG Player", "#{bin}/easyrpg-player"
    end
  end

  test do
    assert_match(/EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v"))
  end
end
