class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.3.tar.gz"
  sha256 "63045d0815e15e963d90b15d5a10edf31a5d72d0ddb5e028e42ba38b0d4368c9"
  license "MPL-2.0"
  revision 1
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url "https://github.com/mgba-emu/mgba/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "c55cfeafb7c6daecb169a1d7ed4c0a5776838c74cf430946000b4d3cbf6315f0" => :catalina
    sha256 "f0e7d35f3006c464adbc24fb34e01946245aea68982342c9f5f5a06732ca6962" => :mojave
    sha256 "6269da0dd599c26563c5bbc1764223d8441e2d38cad15da569b65e5fa37b393a" => :high_sierra
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
