class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.15.tar.gz"
  sha256 "5325cbb6fe96ff80a27584d9fd3ea1d572eb6e21f863fbc72d0d245752b5444e"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "792bba85281821c52b5c4d6385d5aa176e8c8d504df7963ca08f7f8be88dbfb2"
    sha256 arm64_big_sur:  "56305633a054df27bbf05427c2383562b67ac2858d457ed07eb514990d6dbfc6"
    sha256 monterey:       "56747a817de732c3bca91295173a377f872483058d7cb8330d71c697461d2545"
    sha256 big_sur:        "c631ca1b8c5eea6c982f816c115783c79cbc61be4da96b716beca17d6327c4c0"
    sha256 catalina:       "db3634bfc0acac8649b691dbfa76584c8786584187815ea6e4d353f87234fb79"
    sha256 x86_64_linux:   "9cc6bcedd1fdadc4c6ff4d5ea5b65469d23e5e6d816542a2880cc125bead427c"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "help", shell_output("#{bin}/fheroes2 -h 2>&1")
  end
end
