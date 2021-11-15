class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.9.2.tar.gz"
  sha256 "29ca22ebc56b26a4e7224efbb5fa12c9c006563d41990afb0874d048db76add4"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "abaec6f38393e67a34ae5608a96b87b6cfa79c897ed6604e9eed580a1b124f01"
    sha256 cellar: :any, arm64_big_sur:  "748990bd29b7c677472169b38a191bb6845e0380332f674b18acae32bc872a28"
    sha256 cellar: :any, big_sur:        "bbd6ee9c4ef3698e28e58da996235b1c51b085f79f8f9042aff9d9b25950f6dc"
    sha256 cellar: :any, catalina:       "c3719a69184da453cbab9569ca328bde05a46b157fc1b8f1668e7c481e1b161c"
    sha256 cellar: :any, mojave:         "ae8283ff8e328160830007d48d4b1338ffa17e01dd41e3fc9438c447f18c473d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt@5"
  depends_on "sdl2"

  def install
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
