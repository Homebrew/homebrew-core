class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.14.0.tar.gz"
  sha256 "4744005fc3b902fed886ea418df70690caa8e2ff6b5a90f3dd88a3d291ef8e8e"
  revision 6
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "3dc8db5d1589213e9162afe62a3acdc1b08138095f3e0c2166d1c76d853a1c3d" => :mojave
    sha256 "3790ee233fed29e845dd139c4052d9437db29d5c6d1a289875ff7555d0bdea2d" => :high_sierra
    sha256 "cc6a9d807bc65b9678aed753095deedd6ce953b6cf3a6022321ddb8151148e76" => :sierra
  end

  depends_on "cmake"
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
                    "-DGLOG_LIBRARY_DIR_HINTS=#{Formula["glog"].opt_lib}",
                    "-DTBB=OFF"
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
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
