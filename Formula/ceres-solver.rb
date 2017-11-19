class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.13.0.tar.gz"
  sha256 "1df490a197634d3aab0a65687decd362912869c85a61090ff66f073c967a7dcd"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "6b502c59b96b625ef764f347acf66d589b5c53c96a6b7cff980ddf0b5fefbd5b" => :high_sierra
    sha256 "1c9a74db5edc2ae3e3e5af16ef0f71bd4c85256d228b15f17a87065504ff1a04" => :sierra
    sha256 "cab73e79ec9fda737c2bbaa359e5230a6aa698ff96a78ec3e5cd064b1f38393e" => :el_capitan
    sha256 "2586ed1c09a20180c32f4ff5bee7ab0114b6473791f5bfb440c611f0fb998dc5" => :yosemite
  end

  depends_on "cmake" => :run
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                    "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/libmetis.dylib"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html" unless build.head?
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 2.8)
      project(helloworld)
      find_package(Ceres REQUIRED)
      include_directories(${CERES_INCLUDE_DIRS})
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld ${CERES_LIBRARIES})
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld", 0)
  end
end
