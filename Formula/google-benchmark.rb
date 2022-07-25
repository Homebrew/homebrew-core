class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.7.0.tar.gz"
  sha256 "3aff99169fa8bdee356eaa1f691e835a6e57b1efeadb8a0f9f228531158246ac"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e4299672a9265bec364447860af566beea9e7bfa05d1d6a6eb25bbafe483b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9caff21145296947a9326b2d49d734c52f4603d0511c40ed7d8628ca9a907d9"
    sha256 cellar: :any_skip_relocation, monterey:       "2cf32fec60d31acf3cf78175ad99fcaf3f534f9064a672f8d009942b32659538"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c0514cede4c77d154b0d57d2c5a32ff008358d4806dffbb6f1d564429f5f239"
    sha256 cellar: :any_skip_relocation, catalina:       "82481a311f7b82a69f5403f6840ed8c40861bb39730cdf51cff1d1182f0aa888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fce145dd744794ebe89f68c9593d5d2d79a949be94ecfc497de591775722229"
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
