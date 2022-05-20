class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.1.0.tar.gz"
  sha256 "f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6"
  license "BSD-3-Clause"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c727ac20864b6d83a0ca462b57d7aa4f36119eba132565faa9c4a21eec1bf0cb"
    sha256 cellar: :any,                 arm64_big_sur:  "3319708adf812ed908c95dba4984a51f39d49f57d08e71ad2e5b2c124c433348"
    sha256 cellar: :any,                 monterey:       "ab39d83b1ae0299e88f3fc9d5b23f19c98903d6452e21b6d363966ef5f4817d0"
    sha256 cellar: :any,                 big_sur:        "d1918fe281cb00dbb2d773c03252a0d50384688c32cb1ad92510f55c37276dca"
    sha256 cellar: :any,                 catalina:       "d6a945ae9d978b449228a795cfab9ab0061920f6c73f9cb93bb0a72946f4b206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f095246dbff97818863a99864400c25278c6c23ee5bf42546eca75ae04f7de1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
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
