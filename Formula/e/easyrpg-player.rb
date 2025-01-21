class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 6

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66c7961634bf8c5e03ce836f43305bd1c0b26243b11a18bd891fc373598e4126"
    sha256 cellar: :any,                 arm64_sonoma:  "18ca681626d5cd3567cb66c707f852c331bbdff76aa3b3d2ed8d4c20ac58333e"
    sha256 cellar: :any,                 arm64_ventura: "10561454e76eccb05d5a54f019514737275771deba52204d71292247d961da97"
    sha256 cellar: :any,                 sonoma:        "5334ddbe087aa9294f7b7492cd2d263d27cd20dcaa2f17a81c6f7708b350ce5e"
    sha256 cellar: :any,                 ventura:       "8b8cfa026ce4c30fa3fb4b3b1ee9a5830a8635555f19f8dde776c35992100bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6a5222eaa4447b239eb868aceae4dbec632cb4aa2ad4573f99efc99c675b57d"
  end

  depends_on "cmake" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
  end

  # Add support for fmt 10
  patch do
    url "https://github.com/EasyRPG/Player/commit/a4672d2e30db4e4918c8f3580236faed3c9d04c1.patch?full_index=1"
    sha256 "026df27331e441116d2b678992d729f9aec3c30b52ffde98089527a5a25c79eb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/EasyRPG Player.app"
      bin.write_exec_script prefix/"EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv bin/"EasyRPG Player", bin/"easyrpg-player"
    end
  end

  test do
    assert_match "EasyRPG Player #{version}", shell_output("#{bin}/easyrpg-player -v")
  end
end
