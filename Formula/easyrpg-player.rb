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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "35402a4ebf31126dc698f350b6b643e84cdf082348cbf91753ddc2ad1edea8b4"
    sha256 cellar: :any,                 arm64_big_sur:  "cdd4dd54d40d8e659bd0d820deeef99740c46ff2dff90a6d0e788d2a086412bb"
    sha256 cellar: :any,                 monterey:       "7b925302866f43541ae010d252712bdada3062128eb520c0d89cfdc5ce8118e2"
    sha256 cellar: :any,                 big_sur:        "941f5709c777356910481260328d4e7c07bbdb30cd226d52640c631da22736bd"
    sha256 cellar: :any,                 catalina:       "15e33be5dbde27d8df446a845f2ed3a18f36b5d7ae6fdf4f70f7d8af1bbb2df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d1d39d37367d259f49aa643d8070d29b585d3c50ca353a8c33be20e6352463"
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
