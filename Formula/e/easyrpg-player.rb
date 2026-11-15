class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1.1/easyrpg-player-0.8.1.1.tar.xz"
  sha256 "52ab46efdc5253a5ef08d3eee49c84d5c5cbb770929f28a08681fe01e5279bb2"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://easyrpg.org/player/downloads/"
    regex(/href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca5adeb71ccbb08cf59e019751b6e2db80d7dd39f044a3c745ebb1c623fd13d2"
    sha256 cellar: :any, arm64_tahoe:       "1423705f002f0f0e9a6a379ee7417e97c5481ed7f5f5f5bd00192862ab724df8"
    sha256 cellar: :any, arm64_sequoia:     "0f6427b16319fcfa99664fb8420ed44ae64177731d2deb853bf3a7357c3b3751"
    sha256 cellar: :any, arm64_linux:       "0f9487cdde31179cddda6099a776749b82fd5adced8d936dd20114aee8fd3a0d"
    sha256 cellar: :any, x86_64_linux:      "70be3d82da3ab4fd7ac35ec4a996a838b5740279c7ef500d22721bec34b886f1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2-compat"
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

  deny_network_access!

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
