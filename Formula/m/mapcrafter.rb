class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "686ca81e6553b20137845a249547dd5c0bc9eca21e795dee7238784aed8da0af"
    sha256 cellar: :any,                 arm64_ventura:  "2691f7edbb01d1f8972ab1c808025f404463ec86fa9af943fb18a9ac783adf9a"
    sha256 cellar: :any,                 arm64_monterey: "cf591739bbe4f5de38d18348856455adcebf191e1276d527ad62f4dcf6aae79b"
    sha256 cellar: :any,                 sonoma:         "16b5995c15d49481dd4c5b9379607aa178be523df840b29c700a58e3703093e0"
    sha256 cellar: :any,                 ventura:        "1ad1854d8ae46de7df1004772050985b62b75dce9ca12ec5c85a21b80c563865"
    sha256 cellar: :any,                 monterey:       "7055def0f7806a90f0cd64b12015cf65725ac7e7097d0a8978accd61411590af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48422e315761b9032fdba7b4736a17089f0db8d265007656525f8f4188042daf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  # Fix build with `boost` 1.85.0 using open PR.
  # PR ref: https://github.com/mapcrafter/mapcrafter/pull/394
  patch do
    url "https://github.com/mapcrafter/mapcrafter/commit/28dbc86803650eb487782e937cbb4513dbd0a650.patch?full_index=1"
    sha256 "55edc91aee2fbe0727282d8b3e967ac654455e7fb4ca424c490caf7556eca179"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPT_SKIP_TESTS=ON",
                    "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}",
                    "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/Mapcrafter/, shell_output("#{bin}/mapcrafter --version"))
  end
end
