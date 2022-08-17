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
    sha256 cellar: :any,                 arm64_monterey: "a2c5273f9a76fb0b87bfc06025bf31b0eef7cb6f76c239dae727b58ad311b090"
    sha256 cellar: :any,                 arm64_big_sur:  "993ae4fbe9fb337134aedae988cefbc62d24c0ea56519f9dd1c1525ade0695d0"
    sha256 cellar: :any,                 monterey:       "e0d23fd23007b642cacfcfee7b29c41f46fe760bd601749b9639a871b6a9731f"
    sha256 cellar: :any,                 big_sur:        "65d0605d32d94a3d4bb5279c56b8b16d09ed9565c03b7bb514bad0cecff7d021"
    sha256 cellar: :any,                 catalina:       "5ec244da200a93b1f6dc7459351f3ab4b2835a975b530f4755d7faa45389c352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b538c2063295c29c8c5c61c2afcc655d4af2234950f905577834da7623cd4ca2"
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
