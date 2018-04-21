class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.6.3.tar.gz"
  sha256 "35c8906c01206adae714fee9c2bc39698c514a4adb32c9c4a5a3fa58b2d10f9a"
  revision 1
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    cellar :any
    sha256 "ddb088667f1bcf5f1130c5de881317317c2687682f8148b7ad3190ba6522b89f" => :high_sierra
    sha256 "6d744816f42f52e8670a9f8dfb706229120efc8bdf61fa2fe9173fff82468553" => :sierra
    sha256 "6b07074f361f3728d29e66095a7c7861048f65ead7b452d78d61332093c311b0" => :el_capitan
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
