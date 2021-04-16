class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.9.0.tar.gz"
  sha256 "929fb86bfdb00edcd54281b56fe7b20dc3791dbbfb9cc4308c5d64c8e60dcbf8"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "4d28953e205d3db2a39444775daa502205a3f888ea8700467085059fff97c617"
    sha256 big_sur:       "a2310c407e137b1696d756176b1e83b3c7a0201f799b399edeb35e5a443d3889"
    sha256 catalina:      "420625501843495af02112ac12c31e7b126823c846224ffe53c283407b175071"
    sha256 mojave:        "c4ce652eb8bb8cf9bce91b010eb9d9883ed75f9319f599c57935640b0d4284a0"
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
