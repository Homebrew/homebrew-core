class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.11.1.tar.gz"
  sha256 "d2c20729ab5b1198e17725b720128f304f4cfae5c0a8c20d75c0e9c5bdee5860"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f2cb0a6caf8b941d3b5b2ca5cd5ddf7719c1306b6f173358857ff3dcd1d4751"
    sha256 cellar: :any,                 arm64_sonoma:  "7c1b1d29867683878abb83b65de35ddc7f2fb510937fba1860406ee405a93c37"
    sha256 cellar: :any,                 arm64_ventura: "f04ac6a942e2f8bcc8995f7d3f92e873995b2b8bf51ca49244be068f4f0196d6"
    sha256 cellar: :any,                 sonoma:        "ddfb633a73a951f3fcc3a62ce20d393d8e195b3b1869fc8edb2b4409a1736297"
    sha256 cellar: :any,                 ventura:       "9386bbb3ed794f57de94737b9acc2014763119cde5e8595841219db32478a5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea186d48d37c6433cde7bb3ffd31418bf1bb8f49ffc66825575c16b9d2c19785"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
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
