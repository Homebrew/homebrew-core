class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.0.tar.gz"
  sha256 "80468b4eaf128ac5179a3416a02e2a2ef4ab34d90876b179fccd8d505f950440"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "a32abbe9d2f4fbff2cdbb89dc62e1a870af240ceefcb17d5aea083f7fb4d655f"
    sha256 arm64_monterey: "c9ec77d02b1093b67b674e2a3ea719fda143b3f3e08736838791cd555b198e21"
    sha256 arm64_big_sur:  "14248f4986bd21089bb40fe7a1930dd2d3943c7f0472b3f8a6e3df5570613e7b"
    sha256 ventura:        "1e9a98edc985f06cc4f7378f2b05364faee649806f25a38b0b130f9677dff530"
    sha256 monterey:       "9110c6760f98fcb3d23230e340019963cfa8c7a4adc7133fa9444436216fe26a"
    sha256 big_sur:        "f2d77f652b180fbac69cf02fcce377fb6af2fb251e27a7308556a1168bd9ecb3"
    sha256 x86_64_linux:   "46c8eec9bfef8be247b3b85e35f61b9837b4bf578ecffe224c8f1e83c3aa0e4c"
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
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  test do
    io = IO.popen("#{bin}/fheroes2 2>&1")
    io.any? do |line|
      /fheroes2 engine, version:/.match?(line)
    end
  end
end
