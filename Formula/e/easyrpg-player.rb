class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1.1/easyrpg-player-0.8.1.1.tar.xz"
  sha256 "52ab46efdc5253a5ef08d3eee49c84d5c5cbb770929f28a08681fe01e5279bb2"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://easyrpg.org/player/downloads/"
    regex(/href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d68b064595c8cbdd5c098f14d6d44c825fb98a6cd75436d3024177edce4d79cb"
    sha256 cellar: :any,                 arm64_sequoia: "77efe336e1733908004d1fb26f927a9cfa961e8e22adb44258a26e13410e274c"
    sha256 cellar: :any,                 arm64_sonoma:  "af5a6d2c7c2f817dc3bf91f340b5c421cf112e1474ecb177d5911d9205b26cf1"
    sha256 cellar: :any,                 sonoma:        "5f10d972d19d0185dae65942651b83b4b60aed838a45df89efb9691763635d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54fc30c523fb4e5cb8e059cce4f70608fbf5ff562175ec42dc0ac7cc58addd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6bb2d6be07d2f602df98c6e4da8377fbaf186ce2f295845304aa1520aec3ff6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "expat"

  on_macos do
    depends_on "inih"
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
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
