class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.4.tar.gz"
  sha256 "6b94873dac9040fd6fd9f13f76dc48f342e954f3b4cf82717b59601c3a32b72c"
  license "MPL-2.0"
  revision 1
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url "https://github.com/mgba-emu/mgba/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "c90de27629ada8b0df93e28bcc87d924a62c1b8f091dfe97077c960201a159dc" => :catalina
    sha256 "0c12a9b8e3941c5225dc0995735b395340629ab594254c3e1c1d7dc55624ca65" => :mojave
    sha256 "ebfe82b8038558f77a84cf1793ea08bc3bf9f7d03064c5aff32c307746909420" => :high_sierra
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
    # Fix "error: 'future<void>' is unavailable: introduced in macOS 10.8"
    # Reported 11 Dec 2017 https://github.com/mgba-emu/mgba/issues/944
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if MacOS.version <= :el_capitan

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
