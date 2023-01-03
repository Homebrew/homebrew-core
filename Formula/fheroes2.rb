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
    sha256 arm64_ventura:  "c370f68227460b6038f6ce326a22f0c4dae664818145b9b565e373f611d7fb23"
    sha256 arm64_monterey: "5fd524d749d1d9c4551b2d70a6d5abd6769ee047ea378e5c96a3255a827a9f70"
    sha256 arm64_big_sur:  "10218362a884296c3181a3fabefe8a879e7770fc297e3c465fca430b9f0ccbda"
    sha256 ventura:        "0bc3e6ecc76307fa5f903ffbea9b5c009805ca699a93b5b3931817551029baf7"
    sha256 monterey:       "d93d39c5ba9b28ab470886e73df5caf5c7147399d2e8dc8fadd4a57e523abad7"
    sha256 big_sur:        "6145db19d865c581f63869e84c508d3bb988d03868e804e2abcdf56bfdca3ac5"
    sha256 x86_64_linux:   "905ebe3dd3eb53e04b9c4dbef976a2fbfcc084d1e206cfbeabcd2524f936b365"
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
