class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/0.9.8.tar.gz"
  sha256 "e2de2dcf16e262632986d9217663d47458fcd5fa4dfa786a4233e6acdd7d1b39"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "5a1521856e8ca65621015b91542568dfcdfaa3e6cb92d612206f296dee448208"
    sha256 big_sur:       "523afe6a1d558cf319881ec069436838fc4ca7c4fdf4f90ce8557d2c67b1e37d"
    sha256 catalina:      "2a924dca03f3aee82b368ed54081b14277d32e45ed312d23502cd557978d9182"
    sha256 mojave:        "a4564611e49cb8e859c8081ba1e2cf223a3fb7f91e437d20c41b63c1cf532c96"
    sha256 x86_64_linux:  "68f8085a24cb07b443337453e9c36903a0e96cea4f348e85ba5a7c7501a5771e"
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
