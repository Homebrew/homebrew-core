class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.0.0.tar.gz"
  sha256 "10298a1d75ca884aa0507d1abb0e0f04800a92871cd400d4c361b56a777a7603"
  license "BSD-3-Clause"
  revision 3
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "761e7dabc27b9ed859f3e3fc0ed2081467890a79d6ccd7c194b49985729f005b"
    sha256 cellar: :any, big_sur:       "8f6910766d973f7f4899495af247537bd4430e5aba719fab883af0469b66d674"
    sha256 cellar: :any, catalina:      "215354be1a7b912524a4d0d273295894f74a1400d676fc3d6531b5af184d0da3"
    sha256 cellar: :any, mojave:        "447bf09bfa27311ca4b4ff856c8181e06290df204840d2f2563847096ead6c86"
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
