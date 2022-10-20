class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.20.tar.gz"
  sha256 "0d9694f552619fd274e1a0c740c1ecbfa32c8bda661200495e29234e9c13b574"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "74648c5df27e962a39cce8634be073062e2a9d3c6d00cdd110645fa9990d84de"
    sha256 arm64_big_sur:  "c2d96044f13e2de44fa12a95dfc33baee9b1dfa39880df2c296e030ef8328b93"
    sha256 monterey:       "26d89c19abcb4c79f991ce9611dc8a6086a83f0caf1d3ec439919711f63ee317"
    sha256 big_sur:        "647fdc256b53e68692cd0b6a0ca4366d4d2814b9d9fca595e1e7fcfb0f13db88"
    sha256 catalina:       "9e69aedb445dcf522851d6109841a6d38f02c12defbb36d52fb5ea3ac46eb915"
    sha256 x86_64_linux:   "a62dd8776213d13aa94e09220772d60811ce8de3bbdcfec1e8e67b76f8785089"
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
