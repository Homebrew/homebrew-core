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
    rebuild 2
    sha256 arm64_ventura:  "45c1286356bc1a9f23cdcd5f417734a8c15b12a3ef85d12bb9e0bb4625afdaa7"
    sha256 arm64_monterey: "a216bcbb598d3d3cadfb395de2d49c49249c2678dd619d2e87b3d7c22a8fb2a8"
    sha256 arm64_big_sur:  "2db5e2c0e115178c69debeaca9f3fc05a912b496de38f44014c3a3dac0cd81d4"
    sha256 ventura:        "95f6e78df7d0d774a6063c935608afd09c3f356bc8c2b23fca860278a8eba8b7"
    sha256 monterey:       "9a54f7e774773db896120280151ebaf80815c0654ba0b553a98ac4a5888b81db"
    sha256 big_sur:        "d65c569d7507c1b3aa5e5fddb566345ca92bdda3ca6ffca1efd3472490817780"
    sha256 x86_64_linux:   "6bf603523da2369f0dad1f4145fc7f836d2fffddfdcc26cfda5d7361a75dead0"
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

  def caveats
    <<~EOS
      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    io = IO.popen("#{bin}/fheroes2 2>&1")
    io.any? do |line|
      /fheroes2 engine, version:/.match?(line)
    end
  end
end
