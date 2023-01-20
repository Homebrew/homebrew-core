class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.1.0.tar.gz"
  sha256 "f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6"
  license "BSD-3-Clause"
  revision 2
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8afc4d9240edc07cb3c89f975fd4f6ef81a1f0aa76b888623592a65f6ed5ebbc"
    sha256 cellar: :any,                 arm64_monterey: "cb33938e1c8cc0a54239906f22d27d8f2a56d0ec166cc9e8c07ebf315f0f4d25"
    sha256 cellar: :any,                 arm64_big_sur:  "7b24d21ff3863a23a9b9545e9c0a15122782e0d2afda33598342b5e98504a668"
    sha256 cellar: :any,                 ventura:        "19400316cec033c482cef38c75a49e96c1f6bb25011af650a8bf041964a9553b"
    sha256 cellar: :any,                 monterey:       "eb467cbb1fd2960b32c4ee445c9d9e4be8c17ef3ccf15180cb671a5d15b082e9"
    sha256 cellar: :any,                 big_sur:        "cedfd01c68b1139b07c67a1084e614bb7988757e76821d1c88543a8580be6f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f96c61a999be519b46c3020b5a7bcdbf030f22c5ff6fe8ba57e02231d21a6b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  fails_with gcc: "5" # C++17

  # Fix version detection for suite-sparse >= 6.0. Remove in next release.
  patch do
    url "https://github.com/ceres-solver/ceres-solver/commit/352b320ab1b5438a0838aea09cbbf07fa4ff5d71.patch?full_index=1"
    sha256 "0289adbea4cb66ccff57eeb844dd6d6736c37649b6ff329fed73cf0e9461fb53"
  end

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
      find_package(Ceres REQUIRED COMPONENTS SuiteSparse)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
