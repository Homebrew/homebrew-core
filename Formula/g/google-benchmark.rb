class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "3e7059b6b11fb1bbe28e33e02519398ca94c1818874ebed18e504dc6f709be45"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96f66edd70bd4fd5b743b3cb47481c55a0fa6119048566d304f4f4b76f4e3cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70025180f4eefd615cd18012febe749208f4113ea925789dc10ef902adc03dc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c489b8fce7399e3b8e429df45f9c119c405669a86ec10ba1689984732bb8de80"
    sha256 cellar: :any_skip_relocation, sonoma:         "89b959b99ccb917145e426fc38c79f474a48799f86a875a8da3da0edb898250e"
    sha256 cellar: :any_skip_relocation, ventura:        "f49d6f70f17ac2f192674ab9136713bc4be13280fef264cedb47d3e58f25e730"
    sha256 cellar: :any_skip_relocation, monterey:       "2b9200561f16267c54323837a819a9f9c384d8a2318c7caf51b6b6d602b4b816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32cf9bc19a5623a51c97a2bbb200bdb11fb5d444b5d9247b7c1a68225a2855ca"
  end

  depends_on "cmake" => :build

  def install
    args = %w[-DBENCHMARK_ENABLE_GTEST_TESTS=OFF]
    # Workaround for the build misdetecting our compiler features because of superenv.
    args << "-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
