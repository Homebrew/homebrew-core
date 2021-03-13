class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.0.0.tar.gz"
  sha256 "10298a1d75ca884aa0507d1abb0e0f04800a92871cd400d4c361b56a777a7603"
  license "BSD-3-Clause"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6a4b388e2ea9cf7b90477cc7ffa4b19214a93e015b10b75a395d961004dd7f67"
    sha256 cellar: :any, big_sur:       "d07b5cedb61f89df0ea50940be78e5bc7f85148b37621acecb0a92a839abb101"
    sha256 cellar: :any, catalina:      "899895707bdc81ab3f52e9cf3ac06ac9f39139fcb9d171c09181b13cc8510b83"
    sha256 cellar: :any, mojave:        "af829a0467fab9ec10f84b5277724dc977b23f57abf4caa5705199629b8bade9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  # Fix compatibility with TBB 2021.1
  # See https://github.com/ceres-solver/ceres-solver/issues/669
  # Remove in the next release
  patch do
    url "https://github.com/ceres-solver/ceres-solver/commit/941ea13475913ef8322584f7401633de9967ccc8.patch?full_index=1"
    sha256 "c61ca2ff1e92cc2134ba8e154bd9052717ba3fcae085e8f44957b9c22e6aa4ff"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html" unless build.head?
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
