class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/easyrpg-player-0.7.0.tar.xz"
  sha256 "12149f89cc84f3a7f1b412023296cf42041f314d73f683bc6775e7274a1c9fbc"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4d6d21e250a0d98f8c655b845b648b5c4e512aeb6de9190e25dc11479933074"
    sha256 cellar: :any,                 arm64_big_sur:  "86ba836aaad3a38cc862c39e0f41658eb1fc899d8e63763caf4e8c376ad8418a"
    sha256 cellar: :any,                 monterey:       "9151058014064597af9c404f707a5cfad0dbf33662301822aab3541b5dd1d63b"
    sha256 cellar: :any,                 big_sur:        "b1aa0ec02ee7b1faed7a6357aa67f6418480ae03aceddbf6581ba2d30380942b"
    sha256 cellar: :any,                 catalina:       "bf296509905e0a781150b999881e792080687bddbca1c1570847d9a83a3656a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4a2e6397a8909e5a3964584661dd8ea0b397e14f7bae802d0bcf13f3f10c86"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
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
  depends_on "speexdsp"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "gcc"
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
