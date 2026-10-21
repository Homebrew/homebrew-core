class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "acc5c7c0fbed855c4aaa2d7c3c36fb82b0c15c28f4e151e3f679c2fc0aa404af"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cfb010a52dc70ed0f3eae99bc0132197e2a6c8ea098513323127213ba6a9bc4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08aa1d2c26de8f05870eff02b3fff6b90bcb0b74ab64a1cd5f7e35638e45bfb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7409914c8dbb678557f64ff5fccadb64f4549fc5d4b611dd3a7ae4cf31236fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2947b225257fe50e79714ab9166a38096933673b61d5969726f2a1ed930ea65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "76322ee48a1110c2e22923d0cd8aad14e60eff001cff0282e956fb892bef8f41"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[-DBENCHMARK_ENABLE_GTEST_TESTS=OFF]
    # Workaround for the build misdetecting our compiler features because of superenv.
    args << "-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <benchmark/benchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    CPP
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-std=c++17", "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
