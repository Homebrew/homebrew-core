class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.9.1.tar.gz"
  sha256 "c1e5f6c7635dfb015f8c9466638dd55ee7747cdfb0ca69017baf15ec19d727f9"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "04f8c9405cc59416a2231b8c1427cf37919010e6cba9140aa9f03ba4a3354787"
    sha256 big_sur:       "8c1d76139c08fe3cb85c4910e9c0b84382438d79d5c069e55359ae65474ddd70"
    sha256 catalina:      "428282cae9f161de3d30115961dfb362c90fcf22aa7f72803071d692fc1f96d1"
    sha256 mojave:        "8b3b2fad5712a28d4827eaf01ee68ddd7fe5ed7fa186f338243b2f3e87c7c446"
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
