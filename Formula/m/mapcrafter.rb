class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://github.com/mapcrafter/mapcrafter"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4556cc5cdbe849c4749c90f875acf0d6c8fd23161067c32896f21b7774baf55"
    sha256 cellar: :any,                 arm64_sonoma:  "550b5c6e1af585913ca491e70a7ee26f0bf00cca855944852c3c5a407dea44e7"
    sha256 cellar: :any,                 arm64_ventura: "bb17c4f398412e9152aae89cce1dc562abd658ce7260f85f65ec142268e1d970"
    sha256 cellar: :any,                 sonoma:        "c79426460a944b07d0f53856be421471ab5893dd15794e2bdbe740413d926ad4"
    sha256 cellar: :any,                 ventura:       "8b37b8c357fed7bf253a4876aa17e4e1dc33dc1bece5632395149225350b6a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e53d3945f9d2caeac7b028aede4b5a65ff3db01f290f45297395aa4e3132736"
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
