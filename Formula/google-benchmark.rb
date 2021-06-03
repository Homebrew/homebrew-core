class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.4.tar.gz"
  sha256 "e3adf8c98bb38a198822725c0fc6c0ae4711f16fbbf6aeb311d5ad11e5a081b5"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9bdbe5745c883116f03215a3ee95322109d7ba1d84fe169ce35a4e2f8830861"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cee370c53f105e333d4442c6c3d639937943e066fe3efd2ab000af4d96de148"
    sha256 cellar: :any_skip_relocation, catalina:      "86dd7f5118758882564547c788e96cbb424a49e2808dd02fa31d731d2a88e7e8"
    sha256 cellar: :any_skip_relocation, mojave:        "885d097c80a99675a56d730ca2b59279537b6fa5239bc771c5150312f0d9abd5"
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
