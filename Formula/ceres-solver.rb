class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.14.0.tar.gz"
  sha256 "4744005fc3b902fed886ea418df70690caa8e2ff6b5a90f3dd88a3d291ef8e8e"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "57b5eae9c2ef9234d359cbf97fc47a3068b0a1e46eb83777e9814192d91e711a" => :high_sierra
    sha256 "9e3b53ba2aa1b27a5cc7d134d6d707882bb82f2072751774afce73d90ea16e9c" => :sierra
    sha256 "ca6e39f97b1a41ddb3ba7d1135b389825ab68daaf3763fefa7887b59a23317f6" => :el_capitan
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
