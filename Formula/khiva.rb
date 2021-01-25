class Khiva < Formula
  desc "Algorithms to analyse time series"
  homepage "https://khiva.readthedocs.io/"
  url "https://github.com/shapelets/khiva.git",
      tag:      "v0.5.0",
      revision: "c2c72474f98ce3547cbde5f934deabb1b4eda1c9"
  license "MPL-2.0"

  bottle do
    cellar :any
    sha256 "28cddc44c54478884807c063702fec744bc58f177fac0eb4478aa1baa8bb1824" => :big_sur
    sha256 "befa8229bbf8013598ff42d1318c7eb60d63e13e22902d229658954a4362b521" => :catalina
    sha256 "6d9ddb73a8000d9f968717639717d6267e2ba7fb82c13d7a8cc3aefcd40a827b" => :mojave
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "arrayfire"
  depends_on "eigen"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DKHIVA_USE_CONAN=OFF",
                      "-DKHIVA_BUILD_TESTS=OFF",
                      "-DKHIVA_BUILD_BENCHMARKS=OFF",
                      "-DKHIVA_BUILD_JNI_BINDINGS=OFF"
      system "make"
      system "make", "install"
    end
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
