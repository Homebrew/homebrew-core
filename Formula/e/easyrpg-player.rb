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
    sha256 cellar: :any,                 arm64_tahoe:   "010c14b95eb5e8fe48becc6514332b5aa893c70253f3343eb485447d4e29944b"
    sha256 cellar: :any,                 arm64_sequoia: "147cff0fae0012e7b6b9c7067ab1e51696a0c16c67666bedd09013c2a32bad78"
    sha256 cellar: :any,                 arm64_sonoma:  "ed0af9ae907e58d82ae9318ebed9ed031718089b0936762e95689f84df763abd"
    sha256 cellar: :any,                 sonoma:        "66310aa05ec8ee09e282e1dd042e5e860b9f55369b557bb7850d5abd07c06fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2d5f939dea1d2c04a49f0adcb0cd7e906039db2094793a21100821cf316014b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf66f728208ecc9253c29ddc21b0cb6b6afe569d81ff2e85f73dd3c6a1f473c1"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "inih"
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
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
