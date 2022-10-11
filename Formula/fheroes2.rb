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
    sha256 arm64_monterey: "065aa3b261c6f83619f66477f32ab6d1fa3361138c71f9d45e07cd011d81e4d3"
    sha256 arm64_big_sur:  "b27eb57a3066176a8f04cf4d429469887c85d0734f510a2421aee07e7f0e5caf"
    sha256 monterey:       "13120e691abf9ad146c5d2b7f3ca0e22bba69a97d772d1fa1bee8c1d5894d1d1"
    sha256 big_sur:        "96789220a4e788e41a6c1e93b5b4b08a74248f31bed67a20bd443dea9d15ecc3"
    sha256 catalina:       "4b88b8e57d22d831a78543d5c315032b626361283222f79fed9a680fd9918607"
    sha256 x86_64_linux:   "034ad518c130058fb266a235267918ded87229f68acdd0a91ae4a339e2b8a79f"
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
