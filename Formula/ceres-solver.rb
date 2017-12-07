class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.13.0.tar.gz"
  sha256 "1df490a197634d3aab0a65687decd362912869c85a61090ff66f073c967a7dcd"
  revision 2
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "9670c0aedb3e7b93869978ebee2aed1af526d199f55a513156ad79cffcedf679" => :high_sierra
    sha256 "99706f6fc84ce4a6edcbe194cfa5d7e0c005aec43c05c1f7d8c5dc7f57c2fe19" => :sierra
    sha256 "0d42142f5b64203395c8a1d5767461c33e133e589ffad84a965f1efd5b48f62e" => :el_capitan
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
                    "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/libmetis.dylib",
                    "-DGLOG_INCLUDE_DIR_HINTS=#{Formula["glog"].opt_include}",
                    "-DGLOG_LIBRARY_DIR_HINTS=#{Formula["glog"].opt_lib}"
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
