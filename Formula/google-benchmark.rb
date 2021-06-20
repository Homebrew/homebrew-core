class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.5.tar.gz"
  sha256 "3bff5f237c317ddfd8d5a9b96b3eede7c0802e799db520d38ce756a2a46a18a0"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7bc5b628badef224d2d38b09c0377a0be6c1e99c801b04c936c2eb2c6e29b5d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "261bdc680fff541ab76c925e8b341ed32b74e541c5e47e3acc6d51a880d3bac2"
    sha256 cellar: :any_skip_relocation, catalina:      "522669df4933866790f71fdb233af934c3ed2c3ad40ea7b1aa3c0c6aec3d7c3a"
    sha256 cellar: :any_skip_relocation, mojave:        "dbc6f828f0efa63470d1d1da080efc890c6ce5150a839d2e025ba531de867028"
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
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
