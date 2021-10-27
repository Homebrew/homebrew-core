class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.6.0.tar.gz"
  sha256 "1f71c72ce08d2c1310011ea6436b31e39ccab8c2db94186d26657d41747c85d6"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42ea93b4351c4da96577f12309f27bda4b0c89b135f00673422a785dc57218e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac2ad887a8ab80ef3f35f1649eea685fef772b3997d22571dd4079b0cbdaaac"
    sha256 cellar: :any_skip_relocation, monterey:       "d159c7a8e95e47e5ab306c8c039d68534ccf6db85b5c9201af0d35d0a1cd031a"
    sha256 cellar: :any_skip_relocation, big_sur:        "51f30b3d6cc75e55817edf118fb3e3ff26326a6fda89ddfe825cc7ee14b0466f"
    sha256 cellar: :any_skip_relocation, catalina:       "2bf63b419594d52b6bfd2a3a70bc972e8854a25df324de1fe9767dc3afd43b01"
    sha256 cellar: :any_skip_relocation, mojave:         "2f53d7a2fb5622dc85f1d6fc08086395ea464b7ec538059b9b8b8d37e8b9bc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadb938649288a88f2e7f16cc78f27385c197aa72786de75d2d70a65b5861820"
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
