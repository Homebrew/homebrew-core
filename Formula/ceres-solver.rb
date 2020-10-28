class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.0.0.tar.gz"
  sha256 "10298a1d75ca884aa0507d1abb0e0f04800a92871cd400d4c361b56a777a7603"
  license "BSD-3-Clause"
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b361ff56ef92ad9f331eb3555675c41dcda52bb1f00d0918c09a182207689cf4" => :big_sur
    sha256 "73ed3e90a8e53fc6f26826138849ca6083e08a904e693efecc44963f182a5e0d" => :arm64_big_sur
    sha256 "e54c5be54b9a2e8d0af4860148d6e7d7c44edca7ce1c397b54a776c1730f03cd" => :catalina
    sha256 "0a091d6adf630d059340d1c4e69836fc9ecbbac804b23f855095ad9b0473a6b0" => :mojave
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

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
