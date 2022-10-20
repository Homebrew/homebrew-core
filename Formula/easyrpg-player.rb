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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "7face4d8c8de6e677f2666423c7d6351c3ed4e9a8482edf72defffccde372b62"
    sha256 cellar: :any,                 arm64_big_sur:  "3e41830cabf00010ed53932a45b90ffe7f7632a9f53d214d6ab22c9e2a26adc2"
    sha256 cellar: :any,                 monterey:       "8c5959946f1a49fc0b12ef5664dfb76ae59200e4b1789068546f6aa18e322d55"
    sha256 cellar: :any,                 big_sur:        "5d0c23b97aa28f4cd220dffd594f58e85b9593cb8f5fd3c78b09035d19ea62f3"
    sha256 cellar: :any,                 catalina:       "65332c983ecf0e9f4fac9e0dd8672451114ddf40ddb3d131aac6fa7c28918f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "423ad9c8e19c7eaec2674b4811e8dcd2e20b2f8fbd7622e2165e7b31702c5fca"
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
