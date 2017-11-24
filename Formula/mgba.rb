class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.6.1.tar.gz"
  sha256 "7c78feb0aa12930b993ca1b220d282ed178e306621559e48bb168623030eb876"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    cellar :any
    sha256 "eb516a5e5001154133f861a2759dd0125da62d364880a005f1aea223254d6674" => :high_sierra
    sha256 "7305169fad212707dc3e3d46ecd9ede327f79d892c2bf9ccd91fde212d42a0e5" => :sierra
    sha256 "c146125ac5a0ff122b503203e75733ec4b30170207267afc09fc488d3244d339" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
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
