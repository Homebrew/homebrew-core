class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.12.4.tar.gz"
  sha256 "320cb5a411cd0aa713adc05e208ec34067638e776260efd8098271342d408997"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e42be278b60bbdc3906ae2c3ba6a6dd3cb3755613d4f57aa531586020d5dd715"
    sha256 cellar: :any, arm64_sonoma:  "cdb4401a9d09839e2e5d77ff8958ea693c7a1b0e2257168668e7da657ec08bb8"
    sha256 cellar: :any, arm64_ventura: "36e27712e19430345219a35c87736a80622a26367b1469d7c8a49c5cf3d2b01d"
    sha256 cellar: :any, sonoma:        "3d63421f9f0a990561240e4c5a99b30cd03f4f06ff0fd236e55a55d774af0d1a"
    sha256 cellar: :any, ventura:       "75124d0c1e1af9ae54719012955049b7b32219bdb4b433fb291b680423f6ae86"
    sha256               x86_64_linux:  "6f8fd1e4c1d57c2eb169c339d488682202ed1a660092131a715e9241dd0690ab"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/colmap/colmap/pull/3553
  patch do
    url "https://github.com/colmap/colmap/commit/4995ee6ab747fa34372359f1e12f85908bae88b1.patch?full_index=1"
    sha256 "e6112f87997213aabf5a24be8e76a7368b72eee4e96dcd23a28659c5d4292be1"
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
