class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.7.3.tar.gz"
  sha256 "6d5e8ab6f87d3d9fa85af2543db838568dbdfcecd6797f8153f1b3a10b4a8bdd"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "0f10a479ab180103084f35e3e897c5b0a417444366b8ecd27ea4d466a12bcf62" => :mojave
    sha256 "4876e9acb21bbed3eaaf177593a7c17a96149976ca016f9ca87942fa0b641a29" => :high_sierra
    sha256 "fabba640a9ab7f6637132c74f9416d5276eba1e509e7784c092860853be72682" => :sierra
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
