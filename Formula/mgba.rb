class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  revision 2
  head "https://github.com/mgba-emu/mgba.git"

  stable do
    url "https://github.com/mgba-emu/mgba/archive/0.6.1.tar.gz"
    sha256 "7c78feb0aa12930b993ca1b220d282ed178e306621559e48bb168623030eb876"

    # Remove for > 0.6.1
    # Fix "MemoryModel.cpp:102:15: error: no viable overloaded '='"
    # Upstream commit from 11 Dec 2017 "Qt: Fix build with Qt 5.10"
    patch do
      url "https://github.com/mgba-emu/mgba/commit/e31373560.patch?full_index=1"
      sha256 "5311b19dea0848772bdd00b354f9fca741b2bfd2cf65eab8a8c556e6fb748b8e"
    end
  end

  bottle do
    cellar :any
    sha256 "3a84cea85a0429ef1e213acd82b31b9eaf95724e39ea26bdc336a899b95c8e37" => :high_sierra
    sha256 "7599ea9e1fe16fc52933760d484a76bc2c9fceebb26279123f995ae140b0633a" => :sierra
    sha256 "5ff36a9a5e0f0e2970045d93970e49f6825a3e718f3308c5ba3c581c96e9c2a5" => :el_capitan
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
