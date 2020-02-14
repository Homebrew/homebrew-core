class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.0.tar.gz"
  sha256 "77da9416cb60fed10a35feb5d9b5b951cd0187c00c367a1f4d60ffc1b659c6dd"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "309b853492c44b6200c7842e2df58f1f19683e5928634d33eab39bace340bab8" => :catalina
    sha256 "b8ecfd80574ec3ead64f89726d8ba56d007e42b39ac024fbe143b9e8d6fd4203" => :mojave
    sha256 "03a658f45acb46e17e3d7b093d765777e3ad3099cb9c73e3d8140f8bba085b3b" => :high_sierra
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
