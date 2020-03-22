class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.1.tar.gz"
  sha256 "df136ea50c9cca380ab93e00fd8d87811e41a49a804c5b0e018babef0c490f13"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "74846398875420c4fb877be7c646753b852f747c749dee8d9e67c4c64d42941d" => :catalina
    sha256 "ded67173cd9422c5eedf350f740139fdbb6ff80f4d7024098f407c0566296a40" => :mojave
    sha256 "bd290fed1f0f69cdf857fd3f8f7bb41f92c1d50b8af41044407e2daa9b4a2599" => :high_sierra
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
