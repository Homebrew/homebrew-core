class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.4.tar.gz"
  sha256 "6b94873dac9040fd6fd9f13f76dc48f342e954f3b4cf82717b59601c3a32b72c"
  license "MPL-2.0"
  revision 2
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "c7c2dfcf3af79649d5f71ee51fe2cb346adf724d670174ba076a0f680ebaf09c" => :big_sur
    sha256 "7a37aa37bb345914c0ec1f4b89a49e0c10c75b06548927282030a0d4bc48f9cf" => :arm64_big_sur
    sha256 "5c585a38067bcc18296cb1f163b771c3cd38cd7e04cc90fb7ef81c8644c36444" => :catalina
    sha256 "154aea74ade5528132daf55c1880b9c894554ac0465bf082e17b7c2c761a6169" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt"
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
