class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1.1/easyrpg-player-0.8.1.1.tar.xz"
  sha256 "52ab46efdc5253a5ef08d3eee49c84d5c5cbb770929f28a08681fe01e5279bb2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://easyrpg.org/player/downloads/"
    regex(/href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92db38c733393d101b7f408ab5ceffef2b4ed4d738cc736d0cb63b6188b4566f"
    sha256 cellar: :any,                 arm64_sonoma:  "3e856d3375dc9bc24ea8d1daba95b5d70425aa9624bf952de217e80f56b7304a"
    sha256 cellar: :any,                 arm64_ventura: "46a23bf672d452cd6c3a4473703f55cb50f39dbbefc8124e4f55226a1327de5d"
    sha256 cellar: :any,                 sonoma:        "0d18f1c5eff68ac87fc93e05b86d45b99c48476e6264cf0adb5c0aef0bc38d0b"
    sha256 cellar: :any,                 ventura:       "aff66edf7ec8d8349ed07c31617ab0034da3449ff153cf50cf24b0e40b505a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7faaaf67aac67ae3549a3bfd5c80fc43f2c516fbfb962f5094779b81f2736a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2316bb07a7853aa8b92ab96391530ffc09b6c1c5ab91a7db99ac5a5154a2d3af"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
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
