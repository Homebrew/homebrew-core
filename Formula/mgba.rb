class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.9.3.tar.gz"
  sha256 "692ff0ac50e18380df0ff3ee83071f9926715200d0dceedd9d16a028a59537a0"
  license "MPL-2.0"
  revision 1
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "34235cb6f1aaeca67d11e4b060bfd2d7adf462b61b115beb029fd81ec0adc563"
    sha256 cellar: :any, arm64_big_sur:  "0dc3200fa947b5872c48500c3c7b4841668edfc2143d2977226e850fa53db2dd"
    sha256 cellar: :any, monterey:       "8486c6db482c218845f22d3dfbc5402066d002c6712b1fc0faefa3ce88d186f0"
    sha256 cellar: :any, big_sur:        "575163b96818d53848c6b4a536fbccea185cce14487394974519b1655c3cb03f"
    sha256 cellar: :any, catalina:       "fe54e4803c93036beb054b6e649f722e21f1ae08fa4efb4c2808d9b5b875fd8f"
    sha256               x86_64_linux:   "2e521f7ea91d0e5b77583d818c0eed31ece44389d4ac3235dd6ed52bfd6141ae"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt@5"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    if OS.mac?
      bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
    else
      mv bin/"mgba-qt", bin/"mGBA"
    end
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end
