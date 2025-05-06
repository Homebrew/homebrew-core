class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1/easyrpg-player-0.8.1.tar.xz"
  sha256 "51249fbc8da4e3ac2e8371b0d6f9f32ff260096f5478b3b95020e27b031dbd0d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://easyrpg.org/player/downloads/"
    regex(/href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bfcc503e8f0ee35e4b4cd08fc3b813a444608597916333df7b1ad7bcf0a659bc"
    sha256 cellar: :any,                 arm64_sonoma:  "ee4520c62cda9ea8653fa2f12266c8f2bb0f6455ad0ba92160e9aacdf1c43a2a"
    sha256 cellar: :any,                 arm64_ventura: "e1a67c73ebb2639e3ff2cbddd0d0860b7c0115fae59927e35ace0a1e2ce7a7ca"
    sha256 cellar: :any,                 sonoma:        "2139aa0e7aa904cad6ff617cc8aa8e9434ecb18dac1dc3d4d9b988c1946afc14"
    sha256 cellar: :any,                 ventura:       "365b0a8d9c51bb87fbff8e9db4ed61c160009dddfb10582a2c23986487de9449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94349948b5767d07e9aaf715bb2caa41c8568a19bb0ca17c2c579f72d0e58a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5888b347c6ccd8a305ffdc8c076d6f6798348d1e81af7743d87f6bda1d76d3"
  end

  depends_on "cmake" => :build
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
    depends_on "pkgconf" => :build
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
