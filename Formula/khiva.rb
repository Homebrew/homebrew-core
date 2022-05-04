class Khiva < Formula
  desc "Algorithms to analyse time series"
  homepage "https://khiva.readthedocs.io/"
  url "https://github.com/shapelets/khiva.git",
      tag:      "v0.5.0",
      revision: "c2c72474f98ce3547cbde5f934deabb1b4eda1c9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "514fd58094f8ac4120f8a7e8cc600a96357a0ba68c5585acf869e146c30866a6"
    sha256 cellar: :any, monterey:       "cb986b292887168d11bf06007d42b657ee7d2d2407d23b031708a6fd5af97870"
    sha256 cellar: :any, big_sur:        "28cddc44c54478884807c063702fec744bc58f177fac0eb4478aa1baa8bb1824"
    sha256 cellar: :any, catalina:       "befa8229bbf8013598ff42d1318c7eb60d63e13e22902d229658954a4362b521"
    sha256 cellar: :any, mojave:         "6d9ddb73a8000d9f968717639717d6267e2ba7fb82c13d7a8cc3aefcd40a827b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "arrayfire"
  depends_on "eigen"

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
