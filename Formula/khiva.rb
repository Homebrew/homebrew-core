class Khiva < Formula
  desc "Algorithms to analyse time series"
  homepage "https://khiva.readthedocs.io/"
  url "https://github.com/shapelets/khiva.git",
      tag:      "v0.5.0",
      revision: "c2c72474f98ce3547cbde5f934deabb1b4eda1c9"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "399f0456c0b20163d7c38851ab7838a6d9ab4335f01e01073bfedae98f949750"
    sha256 cellar: :any,                 arm64_big_sur:  "c386d039a93dc9f3e96bc0325cda600cfbf2f698f1b45180e712b5baa4227f09"
    sha256 cellar: :any,                 monterey:       "c049efc28517b418e5f613187aa29de8173066442386b409b175291c7becf493"
    sha256 cellar: :any,                 big_sur:        "1a32ac76362d01553dfd4e21dad40e237f686a959e71f19bb0f8b72df1c2da35"
    sha256 cellar: :any,                 catalina:       "25f5bad055a178283a0be93cbdc7c1581aea942ea779704e4099c966a86e6a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f93da3f62b10d0f9158f50f722cace17a29ca66958fda924853af51cbcbe8cc9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "arrayfire"
  depends_on "eigen"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DKHIVA_USE_CONAN=OFF",
                    "-DKHIVA_BUILD_TESTS=OFF",
                    "-DKHIVA_BUILD_BENCHMARKS=OFF",
                    "-DKHIVA_BUILD_JNI_BINDINGS=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/matrixExample.cpp", testpath
    system ENV.cxx, "-std=c++11", "matrixExample.cpp",
                    "-L#{Formula["arrayfire"].opt_lib}", "-laf",
                    "-L#{lib}", "-lkhiva",
                    "-o", "test"
    system "./test"
  end
end
