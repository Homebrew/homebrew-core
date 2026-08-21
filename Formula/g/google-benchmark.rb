class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "9631341c82bac4a288bef951f8b26b41f69021794184ece969f8473977eaa340"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5869b5f29dc83b37a1a7d44bc846149111d1e3b89e27fa3237502c507ce86945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "019455d89f81c72633489b62d4456bc0272ffe1bc77c17f98838c16d48351411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e628bc6a25ea09d254a199a6c1427784e46df9dc98db6684382b946f7f5812"
    sha256 cellar: :any_skip_relocation, sonoma:        "006f44aca539706c9b216afc902219256dd0bf8c018a704cb6f06178b17dfce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a66268855a18d1595ae79c2c0321605009710dfec02cc1ab276dc39e1ee3bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3f4b7908ccd9c1b945a81f41cf07209bdb87c5e397e1ad34f5e271893152d4"
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
