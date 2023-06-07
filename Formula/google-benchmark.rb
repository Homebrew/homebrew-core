class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.8.0.tar.gz"
  sha256 "ea2e94c24ddf6594d15c711c06ccd4486434d9cf3eca954e2af8a20c88f9f172"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df944f6a480092d01ffbc704af6e350f5b3827cc18367b7f97400aba9bc3b9e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c0353a0d05fc733773630b997b3eaf4a7f9809ab29c4b99261d755c429bef11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c310856a039765da07e7afbd76998d8b519175fce9c818c0feebdd62beaa6300"
    sha256 cellar: :any_skip_relocation, ventura:        "6c59b3a7f77b47eb2abc168c4f79c9c975650e60dce59d1aafda828079037c34"
    sha256 cellar: :any_skip_relocation, monterey:       "934cf485763fd7edc74aac663492e71161c7fea2af10e0a097a0901a103bb994"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b29e5dfd0c726c53d34f5bafadc1df3f136b1734982515fa3c65db5188ef2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc827602cb169ec28b2ae4d0ed7d25fc4aca66dcd693d6586a48024bd1344916"
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
