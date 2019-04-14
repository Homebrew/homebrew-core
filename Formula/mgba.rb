class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.7.1.tar.gz"
  sha256 "665fbae8bcfaf3e3f4b83267ce5800b00b98f4bacbb36fc412e3829020019cf4"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "50f4119ba73325c8abd569a04cecbe36b24e4ce229d631f6c2327e708ba90df3" => :mojave
    sha256 "7e1f73f9d0503cd63a50e0cf6557e148545e7871e68f1f5810e019cf345af7fb" => :high_sierra
    sha256 "dd1a8fd71ec97c54ca6c690f7d39c100b3a6450b82fab658fa4d681d80ccae93" => :sierra
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
