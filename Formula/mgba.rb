class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.1.tar.gz"
  sha256 "df136ea50c9cca380ab93e00fd8d87811e41a49a804c5b0e018babef0c490f13"
  revision 1
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "0f98579d167984c58e1946f501666427949e948fce69cc98be9bd525b1aa924e" => :catalina
    sha256 "503bdba850b29faf5e6daf4960cc4203ca24bd99808df5db175afe3d53b90da2" => :mojave
    sha256 "5f2c9f2396102c081bbd389c9d27a3adddb9b4f621859157f45da6840748f848" => :high_sierra
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
