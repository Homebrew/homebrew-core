class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.0.0.tar.gz"
  sha256 "10298a1d75ca884aa0507d1abb0e0f04800a92871cd400d4c361b56a777a7603"
  license "BSD-3-Clause"
  revision 2
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f82d79630c3ae9c7d2745865ae9d0354607b38bd791268e4286b3b5f5de6d693"
    sha256 cellar: :any, big_sur:       "2d59c90c8e23abb2cbc60225e66602e9c01b88d26471b56f35fea6682e419fa1"
    sha256 cellar: :any, catalina:      "2b734a0205576bd38b1c2126eda2b12bf64416980fef4b49a7fcca6c974b4d37"
    sha256 cellar: :any, mojave:        "200706c8cb3b8ebcfbb0e3006f61ee562e8cb981d35d864bf7b6304165cf8dbe"
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
