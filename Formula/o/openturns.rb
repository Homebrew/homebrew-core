class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://github.com/openturns/openturns/archive/refs/tags/v1.28.tar.gz"
  sha256 "8d81ed39004c06b7d5e628daca545a09e4f6b04f790ce33acd4146473b61e1fa"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    manifest_sha256 "a1b2f2975bea9fab623b9b2fec923f8f3f3659bca80f7a71548defe13652d87f"
    sha256 arm64_golden_gate: "2b7d69d31b131a7a9dacb8c689e1320cd4351665f4a122a034edfe22f26708c8"
    sha256 arm64_tahoe:       "ba4fa215dba6f8ed923bc3e2ef276a908283afb63793ee2c573d391f62b38e4c"
    sha256 arm64_sequoia:     "3a2951fc5f3652e0da6a30441b7fbfd2cac5e48b9dc67a4ec87b0a9812dc18f0"
    sha256 arm64_linux:       "dc48cb8647a189be6bfc50bf133f1b476ee2e3bf4c0ba7dac41a7909015802a2"
    sha256 x86_64_linux:      "a5cc22c2b0275992dcf99246eadf9a72deb2ed1c9b96f31aa0ed929c37abbd9d"
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

    blas_vendor = OS.mac? ? "Apple" : "OpenBLAS"
    args << "-DBLA_VENDOR=#{blas_vendor}"
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
