class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.12.tar.gz"
  sha256 "aa0aafde354b2be6b61696c2f669040f467c6ab6359875b11b3c58bd18690a37"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "e576740ff5d1b1c0b4adfa19da56cd31e74fd21a221f61cc95d726e6aa1c40ed"
    sha256 arm64_big_sur:  "f4f64b20647ff4eb125eab7af50e3cfa8ccb4d26911a7d188a84e60eec957709"
    sha256 monterey:       "879763ee0e1b57c8842459753605a43c641a404bdba752878a86cdda7bdbcfbf"
    sha256 big_sur:        "fb6d6411e764a697d34dc52b9bc0852c466f4b038b3b50c30ba45096bc56ea0e"
    sha256 catalina:       "8f6a31ffcba22ba95ad9b63fcbc9bb107b131e9881050adc9c3cbe757bf89c60"
    sha256 x86_64_linux:   "3e1c28af5d3efdbcfc4cbd0bb9ad46acbeb50c5d5c6bbc31c2570784aeb722f2"
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
