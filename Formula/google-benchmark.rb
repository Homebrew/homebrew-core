class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.0.tar.gz"
  sha256 "3c6a165b6ecc948967a1ead710d4a181d7b0fbcaa183ef7ea84604994966221a"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d7902db4dfdcc4a0c6e928fe2ef178238b5e4d4ca0c02f536fd8c94d8f2c7c6" => :catalina
    sha256 "e2acb14eb43b34f2ccb30ff82a0efd540c3ff0ee9a036a83a00187980457ab17" => :mojave
    sha256 "d9a78a0c14c161ca9c490605f2800328fc5899ffc98cec09af1bd0622338dcc5" => :high_sierra
    sha256 "27cfc3243938226aca675a93ec347bb1a15e482ccfb95b356352b2f1391ac4d1" => :sierra
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
