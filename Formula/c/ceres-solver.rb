class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  license "BSD-3-Clause"
  revision 5
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  stable do
    url "https://distfiles.macports.org/ceres-solver/ceres-solver-2.2.0.tar.gz"
    mirror "http://ceres-solver.org/ceres-solver-2.2.0.tar.gz"
    sha256 "48b2302a7986ece172898477c3bcd6deb8fb5cf19b3327bc49969aad4cede82d"

    # Backport support for eigen 5.0.0
    patch :DATA # https://github.com/ceres-solver/ceres-solver/commit/f0720aeb84ec7bb479fe3618b30fa54981baf8fd
    patch do
      url "https://github.com/ceres-solver/ceres-solver/commit/f9b7b6651b108136a16df44d91fb31735645f5a7.patch?full_index=1"
      sha256 "019006cc850b19b442e108118c599c98b18af8eb06ab37c22e6698c55d55a512"
    end
  end

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53db40f44352513457201e3b1f39f75bdf6370efd63d296d6fb41c000a91ae6f"
    sha256 cellar: :any,                 arm64_sequoia: "1887108ba7e5c6d4fa7ba55a6831f13a0a1ab84dd9250867645510c2ef30b2aa"
    sha256 cellar: :any,                 arm64_sonoma:  "357c59a8eb32e9655e7cf42be0efdb4d69452b315d9d822c9033e80d8c278a0b"
    sha256 cellar: :any,                 sonoma:        "99a382dc87fc7364c7b329d261110f2816ba31a19f9d9ff84c5221aa400eb6c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dc12f8c9a8fe43f8621fa6c8c8959746fb8b9eea1be58383ff59c3fa3d1decd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66a1a131463a22f2ed31bbb5b4d698a73c23719ba5c07c9ebb69efb1863e779b"
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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(helloworld)
      find_package(Ceres REQUIRED COMPONENTS SuiteSparse)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    CMAKE

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    assert_match "CONVERGENCE", shell_output("./build/helloworld")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index f53e9981b..af932c6a7 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -234,17 +234,9 @@ unset(CERES_COMPILE_OPTIONS)
 
 # Eigen.
 # Eigen delivers Eigen3Config.cmake since v3.3.3
-find_package(Eigen3 3.3 REQUIRED)
+find_package(Eigen3 3.3.4 REQUIRED NO_MODULE)
 if (Eigen3_FOUND)
   message("-- Found Eigen version ${Eigen3_VERSION}: ${Eigen3_DIR}")
-  if (CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64.*|AARCH64.*)" AND
-      Eigen3_VERSION VERSION_LESS 3.3.4)
-    # As per issue #289: https://github.com/ceres-solver/ceres-solver/issues/289
-    # the bundle_adjustment_test will fail for Eigen < 3.3.4 on aarch64.
-    message(FATAL_ERROR "-- Ceres requires Eigen version >= 3.3.4 on aarch64. "
-      "Detected version of Eigen is: ${Eigen3_VERSION}.")
-  endif()
-
   if (EIGENSPARSE)
     message("-- Enabling use of Eigen as a sparse linear algebra library.")
     list(APPEND CERES_COMPILE_OPTIONS CERES_USE_EIGEN_SPARSE)
