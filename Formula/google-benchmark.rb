class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.4.tar.gz"
  sha256 "e3adf8c98bb38a198822725c0fc6c0ae4711f16fbbf6aeb311d5ad11e5a081b5"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d097de756dd4f5959334d033736f3046b841cfb834af92daf62f15b46dc82ba0"
    sha256 cellar: :any_skip_relocation, big_sur:       "93009a5d8090d75273b8a0e3cf0bce67508c97ff974b4e47f12a43a9020d1d2f"
    sha256 cellar: :any_skip_relocation, catalina:      "0351832c3848ed1c885e88c41f36f26e25142603f81e13ec28dfab99fb74de40"
    sha256 cellar: :any_skip_relocation, mojave:        "fb72bb473bf016fac7229f21a7c1f973b42cdbaf5f0bfac7ab29ecddeeabade2"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <benchmark/benchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    EOS
    flags = ["-stdlib=libc++", "-I#{include}", "-L#{lib}", "-lbenchmark"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
