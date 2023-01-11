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
    sha256 arm64_ventura:  "9456f4984fe046c3ff9be56a644f4d3b6b9e22ba59321ef6bb9f39986fe99ea5"
    sha256 arm64_monterey: "fda5f57d8ace572ad6ff1b3457a47077882140d707a1076a8c1a32938ca43ee8"
    sha256 arm64_big_sur:  "23038b35ba70a5a7a23847607ad84706d14bc507854cdb946a9e47cf3dab6fbe"
    sha256 ventura:        "4803a421edbeae11303feee604ded130d8f5457a7bae15451e43b2390853f625"
    sha256 monterey:       "7c3646e7cbd567454301e2917e3e9286624d565d2ba200396f6d376374ff881c"
    sha256 big_sur:        "eebee6cce324280243304e19398b22a19bd60efbd04dbd0658fe2285c7e724ca"
    sha256 catalina:       "9b0054aa6bb75a4afbb22d413e241e54c2fb77243ed5fc712bd74dcc8022f527"
    sha256 x86_64_linux:   "4c2aed6811fbc6349bf76f323e935f3c21d841b48fb50ec7d0d55aff9aba4727"
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
