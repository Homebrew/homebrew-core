class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.1.tar.gz"
  sha256 "df136ea50c9cca380ab93e00fd8d87811e41a49a804c5b0e018babef0c490f13"
  license "MPL-2.0"
  revision 2
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "725b64e2132aecbf40204da4c96a5656672724c916213158e820278ba8c269f3" => :catalina
    sha256 "c5b2bd58f48bf590aa55160ec3f51d34c18fc272c6e39cae2e72db31df23bd38" => :mojave
    sha256 "b83acf3eb47d4d2b381d07d39893f55488199efaf1202722240e7cd0b54899ad" => :high_sierra
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
