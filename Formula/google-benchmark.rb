class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.4.1.tar.gz"
  sha256 "f8e525db3c42efc9c7f3bc5176a8fa893a9a9920bbd08cef30fb56a51854d60d"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "038a46b4f7139afe7e8e7fe5da555d850e0f39d79194873ddfe00a9aefd668fa" => :mojave
    sha256 "d3a9c1aa49fd97e55567a04255cbcb3b580e7cee8f9a3a3c0de78358b72bfd69" => :high_sierra
    sha256 "14c6adb0f7f835bdd5477a6a2ae1d4b4b835ad7a9b71dcfddfbe361bef54a147" => :sierra
    sha256 "913d4450128edb4509f2cf8a9168fad45fb5e14d0f6808d81694ad0a20c45ec1" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

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
