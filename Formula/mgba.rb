class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.10.2.tar.gz"
  sha256 "60afef8fb79ba1f7be565b737bae73c6604a790391c737f291482a7422d675ae"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8a01f0e0562af8cb5a58b8b9ef089159002747fdade3a746751b7e7fd44caaa3"
    sha256 arm64_monterey: "dff0877c59dafa63c99d1735dea2c4ddd09fb564eb8efe19f5d67ba2dda15ba0"
    sha256 arm64_big_sur:  "3c7f0aaeb426d5b8d593a0d175fcad2757754526086f7794a344420147098dcf"
    sha256 ventura:        "d6f79090787f191d316913200d1748a3d85b49c1100a252f805468d8f738442f"
    sha256 monterey:       "af5abb8475e09cbae796e36b092decac955b72acd1e9e00b9f3985cef254e02d"
    sha256 big_sur:        "3871054a2087992682c50f572355988901f433c18ebeeca7268d1abe8efc377b"
    sha256 x86_64_linux:   "4e31917f09b4230346e5f06a46de2a0fbdacc417312c68484bc107b2028c3fcc"
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
