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
    sha256 cellar: :any,                 arm64_tahoe:   "5de9c75a8c7d264f7d4f1a616217f5a16a02b3d250b54fb10580bd9b37bf34da"
    sha256 cellar: :any,                 arm64_sequoia: "0a8710868acbc7f3656075feea5664dd8f42bbdf721b4d06da8a4243b112a089"
    sha256 cellar: :any,                 arm64_sonoma:  "2a153ed5437c1c939d400dbf7b852535e282fb98b5fe85114a1faf69bf95b0ef"
    sha256 cellar: :any,                 sonoma:        "e777e7802808b967c0e7c49c56769ee6d489d0e915e276373fc6d926d39adb92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c29ee38ec8613957912297dd62cc1f943dab7611d0bde8b4bb0cdb15ac4315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7685363f268169dfd9314d3cb4bfe9a33cefcbad2428e36440f389b65eb4ab9b"
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
