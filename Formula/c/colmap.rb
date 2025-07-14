class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.12.1.tar.gz"
  sha256 "366496caca43e73a1e61c7ebd9dee51d5b2afe15c0e75e16ebad6cfae6f2860b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "98d3b4c9c372d4c4acd452dfe97a18ac4fb6ae57f39d15af553ebb59285557dd"
    sha256 cellar: :any, arm64_sonoma:  "975fc5da61062d709057c2943881f3a6ce33b899ad83793107cae17c6bbbb2a5"
    sha256 cellar: :any, arm64_ventura: "028608ebd110e37eb68ee0095d0b02a2af4f205d7057293fcf83e5d1f8e14653"
    sha256 cellar: :any, sonoma:        "a3790cb22b18d756f6c8daa73bc88e54a061e725ad6cef7c64426a103807c42c"
    sha256 cellar: :any, ventura:       "db54e91f7ea1bfeeaeda7ebd9e43dd60d6c4e008eacc290e85a3f7ce49e6ea1a"
    sha256               x86_64_linux:  "3f6f9ec7976a499585b3436db564980efec741466658c4111efeb3d91754f5a2"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "faiss"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "poselib"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
