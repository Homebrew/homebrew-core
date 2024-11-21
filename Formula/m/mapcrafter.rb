class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "60fca734c298eb1039dc344ade09695af622b5f95dc7e11c79be16a9fbcf068e"
    sha256 cellar: :any,                 arm64_sonoma:   "0ac68289b87661674d36a17db3f8d5e2b7d62157b498f8f61303ba9cc03d2bb1"
    sha256 cellar: :any,                 arm64_ventura:  "adc4706a3918b77f0e24d5be8368bc541ab17aa4b54f1f37c0cb1381ab0826a9"
    sha256 cellar: :any,                 arm64_monterey: "3d9064ce98db9b600d973ac52b2f7f7cb5c54e86cbd64b306f80672380a55c95"
    sha256 cellar: :any,                 sonoma:         "a505e7b1c29277a49fa93fb323ef245bf51375f8e912d36c433ea717de78d650"
    sha256 cellar: :any,                 ventura:        "f202f39f3ba25cf97451252e430467bf2433529fb5a39c494589900fcc214e2e"
    sha256 cellar: :any,                 monterey:       "cb1448294bbf586aad34ec1943a34faba19a973e0ac4f415daafe46f7a234f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3a10dac4592c2582e0fe73ed16f0e9234a39c69f9115584a01b157440681d4"
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
