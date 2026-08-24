class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://github.com/openturns/openturns/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "6cd10e65682a09a5c8f7b40e3b4926d64fc93dcdff19c0e432ec843886cc1bc2"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2f150a1b12c631f1d86abf83327222c98410292d937f35d4f38404be16cd0c0e"
    sha256 arm64_sequoia: "ba3391c01827910522fca5736530d941911dacde3d870178e9cb2b7e144e6802"
    sha256 arm64_sonoma:  "a284e8de20f151f73c7ca8e0e2a94bc6bcaf211b1a8e13dba02415383ebed5fa"
    sha256 sonoma:        "62828cc8463fa2a7409bcfa9ca5deac8b927bb8c51124df23ce0ed1b4fd62435"
    sha256 arm64_linux:   "510dd85645562892344ab26d036cabf02e5d4bf7e95c6affc7ac606ea49804dc"
    sha256 x86_64_linux:  "a5c2832548ef87987705919b55382328f649b5b3332c66da834edf75d125a132"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "nanoflann" => :build
  depends_on "spectra" => :build

  depends_on "cminpack"
  depends_on "hdf5"
  depends_on "highs"
  depends_on "ipopt"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "nlopt"
  depends_on "pagmo"
  depends_on "primesieve"
  depends_on "tbb"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %w[
      -DBUILD_PYTHON=OFF
      -DCMAKE_UNITY_BUILD=ON
      -DCMAKE_UNITY_BUILD_BATCH_SIZE=32
    ]

    args << "-DBLA_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}"
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <openturns/OT.hxx>
      #include <iostream>
      int main() {
        OT::Normal distribution(0.0, 1.0);
        std::cout << distribution.getMean()[0] << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lOT", "-o", "test"
    assert_equal "0", shell_output("./test").strip
  end
end
