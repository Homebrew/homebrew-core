class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.9.3.tar.gz"
  sha256 "692ff0ac50e18380df0ff3ee83071f9926715200d0dceedd9d16a028a59537a0"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b43e9bc82af3fad71b480d17382d77f230f3cdaefa51ff2414a554d6669e4c2d"
    sha256 cellar: :any, arm64_big_sur:  "2dfa4c952ae73dc9d4bcd06b633b42b3845ffe57961d454fd8ad31262b9deae6"
    sha256 cellar: :any, big_sur:        "1dce1e0a22091d6286bf1fc130808d4b9a15e0fb1929aceda6882cdd7f88f672"
    sha256 cellar: :any, catalina:       "462850dbac48418582caa81bde7c007ed0d1f07635496de1ee3def21317ac0b9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt@5"
  depends_on "sdl2"

  def install
    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end
