class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.4.tar.gz"
  sha256 "6b94873dac9040fd6fd9f13f76dc48f342e954f3b4cf82717b59601c3a32b72c"
  license "MPL-2.0"
  revision 3
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "2e960f93ae91956ddbbf80541ca176d92585cadc4f3d0537bfc7a166ea9e6e59"
    sha256 big_sur:       "b6534f335f4c25154cf5e38913a3b5166bf7e96c884409b54219032c34346459"
    sha256 catalina:      "ae0565f81f06458602216f061e52872d2e5a20ba1399577d1819e507c66e08fe"
    sha256 mojave:        "b98b2cc7c4d6a8cc6af107196c290538d8555656a27c46844e1c169ceb4e8181"
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
