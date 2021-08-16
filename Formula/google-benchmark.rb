class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.6.tar.gz"
  sha256 "789f85b4810d13ff803834ea75999e41b326405d83d6a538baf01499eda96102"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e76e7e6cda7fab9b28f65027856bac7395a77aee553a24e930b2b64f0cb5e12d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d23a84b5b2c4e0f4d51bced0c90498f826fe3924c332c3b158848d87b94feb75"
    sha256 cellar: :any_skip_relocation, catalina:      "709fe9fd9c19b733aa58a01b691bd50b4edf81f1d9f46013a81a28ceab70fb5d"
    sha256 cellar: :any_skip_relocation, mojave:        "67dfea1fc615c0d07aeaa061c8e7b32a639ca37d2d30ff7a3fc94018de42207f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b673de871f65915e9e6ec11d1b39e6466c2b8519006f163ac4b076a54ccff59"
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
