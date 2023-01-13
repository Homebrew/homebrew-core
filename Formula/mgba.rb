class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.10.1.tar.gz"
  sha256 "5fc1d7ac139fe51ef71782d5de12d11246563cdebd685354b6188fdc82a84bdf"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "584bde4b0f0d0baa337a4fceedaff49e7f234d41d6b8aaed8e036571abed575c"
    sha256 arm64_monterey: "4aaeb726cf6617932f74a21f955ddb10d64ef5cdb299054f4926f39f013143e6"
    sha256 arm64_big_sur:  "c0b2a3a4aa9e1de968df9e8f1503b7ee81fecfd37bc44389f58cb4072494fb0c"
    sha256 ventura:        "fea6b0f43e41647bd8e3bf94d2d311e133fd56bfb0a264a599f9e6a5d6cec688"
    sha256 monterey:       "9932d3d66de37e3c724860551764ce5c19e89bfc97e823b36f32cbd8d411089b"
    sha256 big_sur:        "4989c70fecfe563140e844a04ce126c5e25a6faf7b2f76474bbfde876a08bbbc"
    sha256 x86_64_linux:   "ba11dc52534a5970901684e57fe58a07871c6fcee7b8c644075101c2e7ddce2b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "lua"
  depends_on "qt@5"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    if OS.mac?
      bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
    else
      mv bin/"mgba-qt", bin/"mGBA"
    end
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end
