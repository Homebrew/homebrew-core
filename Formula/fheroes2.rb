class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.21.tar.gz"
  sha256 "863e78cd239b577068957843d5926fccf72c8bfd0531522cc242040f3108341c"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6a73e94c8df18177f049d3785ef4e28a0267b91472ebcac0d146bb131eca7399"
    sha256 arm64_monterey: "e67d12fdc4e5f8373bcdf8594f8b568bb597dd72979c07b13c242c2ef6743abb"
    sha256 arm64_big_sur:  "e0b060803bc67b57b82957c0cf8522c051725a56daab79b459c98d9b873be54e"
    sha256 ventura:        "b978a8e383c0e6281d1df10de85c1d8801dbf556e03b6d278b4e0cf14d69012e"
    sha256 monterey:       "0d6035e9935f6cdae70763d9ead23e85120633edc51789dc4b42007f2f4d2567"
    sha256 big_sur:        "a279a685c019074c94626ed1d600f7f7b9b961a6c2194f793a5e30de8241fb12"
    sha256 catalina:       "2aeeb745b4259d6da07077738d970e81a3a321f56ac7acc2ed91fc24a4275b32"
    sha256 x86_64_linux:   "d956e5e5e27acae5b567741dbfeee3a768cd4abd5fc48f8bc9f306db5452c767"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
  end

  test do
    assert_match "help", shell_output("#{bin}/fheroes2 -h 2>&1")
  end
end
