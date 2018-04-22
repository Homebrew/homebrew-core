class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.6.3.tar.gz"
  sha256 "35c8906c01206adae714fee9c2bc39698c514a4adb32c9c4a5a3fa58b2d10f9a"
  revision 1
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    cellar :any
    sha256 "cfac5b8353c5525068a609721fa1f500956042908c7b478c94af7fe14c061997" => :high_sierra
    sha256 "11b2ca685b7e76b052d4873b44497108d4bdcc35bd7b20b06d4636fefa18e3b2" => :sierra
    sha256 "f9ee16d6dddb2ac47cc4c1b788ce01bfa172bae78ffc14351b9c1d38696a44dc" => :el_capitan
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
    # Fix "error: 'future<void>' is unavailable: introduced in macOS 10.8"
    # Reported 11 Dec 2017 https://github.com/mgba-emu/mgba/issues/944
    if MacOS.version <= :el_capitan
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

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
