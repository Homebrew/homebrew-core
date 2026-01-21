class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  license "BSD-3-Clause"
  revision 6

  stable do
    url "https://distfiles.macports.org/ceres-solver/ceres-solver-2.2.0.tar.gz"
    mirror "http://ceres-solver.org/ceres-solver-2.2.0.tar.gz"
    sha256 "48b2302a7986ece172898477c3bcd6deb8fb5cf19b3327bc49969aad4cede82d"

    depends_on "gflags"
    depends_on "glog"

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
    sha256 cellar: :any,                 arm64_tahoe:   "8bca5dac2f24d423391151bf8fb69c53b119eb94e5ba899f95fe961cac036ee7"
    sha256 cellar: :any,                 arm64_sequoia: "05cf5a6bb6673ae173ed0832fdd1fa8fcfe5a7fd4db1947510f0f61501d94984"
    sha256 cellar: :any,                 arm64_sonoma:  "bd3d4182288ca1689514d81fccb367151585e4a12acb015a59c2726831230cc7"
    sha256 cellar: :any,                 sonoma:        "0f8775984f506622a7760a114108ea0623708e4657f4b0763f5fa2fd85d73aed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cff4740905f47653e817429811c68ed7d7f8615c988bac94778eefd49896c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9827d7d0b9acc123b2d2841d8755be3ff1e4761917740fcd35f4836006360101"
  end

  head do
    url "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

    depends_on "abseil"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  def install
    rm_r "third_party" if build.head?

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
