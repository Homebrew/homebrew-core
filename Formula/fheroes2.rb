class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.18.tar.gz"
  sha256 "bcd9afce7b869630f97cfdb713668f0f7dccf69fc6b31db1ca74ac2f63524a8d"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "47f4a8336778e11c7f6eb11ec2251a661d739d4d3d4ca00153942b7fd82bbe3b"
    sha256 arm64_big_sur:  "62d964a871ed55bcf12f933754bab754fe39d3af209d3740fc6a3cc40ec5cb07"
    sha256 monterey:       "a7f757ac4c2468bbab0e87359fe0116e9b15a928ec1af8117c6931a6d56af585"
    sha256 big_sur:        "5a56a45450fa2ead28aeb3e7e3d96cfb8007e326cbd25597079265a56453daa3"
    sha256 catalina:       "3585707b2f70fc524f4714362928b4ff8d90d6c9f3038faa12cfabef1fc109ef"
    sha256 x86_64_linux:   "7b72498452c57834bdc3afe97b39f6b00b35da4d720a4faabd8afd25336f20f9"
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
