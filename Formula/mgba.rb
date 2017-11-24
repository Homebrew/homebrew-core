class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.6.1.tar.gz"
  sha256 "7c78feb0aa12930b993ca1b220d282ed178e306621559e48bb168623030eb876"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    cellar :any
    sha256 "b1b8e1cc12513830ebba82ce391fb44984dcccd503608b8b0d214ab7c7e93c95" => :high_sierra
    sha256 "913b8ea3f4268206dc3a633189c61301d5aa69677e616d7ab331a22f2abfdb87" => :sierra
    sha256 "bc9f25939e113ff965b5ac747dd04ef9145679ddba246814215662bbcac7a50c" => :el_capitan
    sha256 "d8feb2b07ced1d12548512c02bb9b53b765a04557819b390c6e9578527460ae9" => :yosemite
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
