class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.8.tar.gz"
  sha256 "02288f8f61692fe38049d65608ed832b31246e7792692376afb712fa4cef8775"
  license "BSD-3-Clause"

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
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  def install
    ENV.append "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/colmap", "-h"
  end
end
