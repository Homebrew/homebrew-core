class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.1.0.tar.gz"
  sha256 "f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6"
  license "BSD-3-Clause"
  revision 3
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "132406aae22f9f085d7c02375cb22a80988b569c0a12153d716398509bca764d"
    sha256 cellar: :any,                 arm64_monterey: "02ae1599d8c04f6425e8a2df4448d57b37eed0f31fb486cbb934c7e3e4e6949e"
    sha256 cellar: :any,                 arm64_big_sur:  "8a3d92ac03ad8b52224713c088064c4452c5b2a1f40c558d5f6030d91a2d0883"
    sha256 cellar: :any,                 ventura:        "38bfcce75b8606172c39bcd3a4adfc988b9d90e59e3b595d0536bfb1f9561bdd"
    sha256 cellar: :any,                 monterey:       "fe17f43c5efbe5113c7bfe424c8db2b9601cd9f4bdb1fb1ed3efad250e05d094"
    sha256 cellar: :any,                 big_sur:        "7b81e35e58838e4ba4e78cecb9598ad6d8f738f24c665942c5f0cc13bf17686a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6542b1fc620acf916a4e22b92552bb81d35abe3a7381975a3389568cc0fe185a"
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
    system "cmake", "-S", ".", "-B", "homebrew-build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''",
                    *std_cmake_args
    system "cmake", "--build", "homebrew-build"
    system "cmake", "--install", "homebrew-build"
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

    system "cmake", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
