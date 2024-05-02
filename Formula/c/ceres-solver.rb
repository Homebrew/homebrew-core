class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.2.0.tar.gz"
  sha256 "48b2302a7986ece172898477c3bcd6deb8fb5cf19b3327bc49969aad4cede82d"
  license "BSD-3-Clause"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82321500433aa189b94707782c92b280d9f370c2da70d81f337c33e7d3ce0924"
    sha256 cellar: :any,                 arm64_ventura:  "7b298b5e784c97df200a87e5ecb612c6a8a3feaff2b7906a47254822c697ddfa"
    sha256 cellar: :any,                 arm64_monterey: "3de5b3e4c7e884954abc07b9456ec86e08cc98dc172194b2ab7781d354ccc412"
    sha256 cellar: :any,                 sonoma:         "f949ae21f99855aa96d25e8cb2a30cf7d001b8af8193a9b0ab4032969c5ab6a9"
    sha256 cellar: :any,                 ventura:        "0fb671f15c3b25e771ebeacb0bd8cfe5f3b47535c766091e24adc6f50e7e4e23"
    sha256 cellar: :any,                 monterey:       "c3dce08c0c5c4c239c60fad44ebe52333428f4925fd3f69faa30d1ad34d11f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68107edf1952d270ebdad753857acf97e253956b48cd115047d89b6364c3f903"
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
