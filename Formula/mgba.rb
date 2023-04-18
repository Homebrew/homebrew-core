class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.10.1.tar.gz"
  sha256 "5fc1d7ac139fe51ef71782d5de12d11246563cdebd685354b6188fdc82a84bdf"
  license "MPL-2.0"
  revision 1
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "52e22f1e84765d62cdb8a8820f7bed769627485df252a65fbe8c30d8081466ed"
    sha256 arm64_monterey: "b59fc12532be713c97cf56ec82a05409b3febd00f2d8b16d37cb203156a19c80"
    sha256 arm64_big_sur:  "9d97e42e89e9a3d1e3fbdbe039e96493ec4b34bd58b22e1b14d50db22ccabfb1"
    sha256 ventura:        "05c5764a534131562c5b3c76c091e56c8b65039d0802dd875163c05dd1440333"
    sha256 monterey:       "0b597f3945cfab3beb96bca90f6196645ab72d42d40fa1085406f4be987d05ea"
    sha256 big_sur:        "a48c2ea3723b52cc1195d6ad7bd100909bf8c021b81e9c9a61a1e34bdc056952"
    sha256 x86_64_linux:   "1177e9fe63038f8d9ae84fae05c25d8cdb76a32bf4b64da84343fe249cbba4bd"
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
