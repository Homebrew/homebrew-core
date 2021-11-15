class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/0.9.9.tar.gz"
  sha256 "a8d5b20c3f1fc98d36676781fc216d1db5385a9e11cf936db0005e9fae5834cb"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f7cd5c1a7603819cdbb80db7b5288fcfd57dc7a54b6e2a9cc89c95b525f1dde3"
    sha256 arm64_big_sur:  "551208f1d3f5cea1e3e0760eeec9c246f9d86f5d21cfb51241d153e3f25d62ee"
    sha256 monterey:       "0b190837beb94e42b6047f75688633a6c1b7a3be23c491b0e6bd6b90f4698c9e"
    sha256 big_sur:        "58a8914823467db3029c590580aa4cc148066b20419dd6d47f54d5ff757e651e"
    sha256 catalina:       "18866b247b645d309b5ca0b3c026e63056e6a39a0cc658cf3e592fedf40ce6e9"
    sha256 x86_64_linux:   "26fe34e7b7f092b16b05c0369fe60d76c6739b24acd7f4becb2dd96d27202f23"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "make", "-C", "files/lang"

    (pkgshare/"files/lang").install Dir["files/lang/*.mo"]
    pkgshare.install "fheroes2.key"
    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
  end

  test do
    assert_match "help", shell_output("#{bin}/fheroes2 -h 2>&1")
  end
end
