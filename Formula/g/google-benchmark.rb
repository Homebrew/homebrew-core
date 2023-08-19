class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.8.2.tar.gz"
  sha256 "2aab2980d0376137f969d92848fbb68216abb07633034534fc8c65cc4e7a0e93"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4754757d1d3700bef189623df82b92d5a32754c6fed8b3bac788b675433c4d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b15e602d13406eadd213ccbfc1b04e6036bbd732cb5708c15e99d039ef9f4ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077889ac682d423ed5d8b341a709c89a94c5c77fc523e92d1566965e6d2ff5b4"
    sha256 cellar: :any_skip_relocation, ventura:        "20fa119c2ff7a7a624f58573724ffc77e716f5ab3127a0b2adb5f5bc0362a4e5"
    sha256 cellar: :any_skip_relocation, monterey:       "df0f32f20dd94536c7e9dc4af8d29bf9d1a67ba06e5b490d217d0697c1b1f24c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6d56e471e33602741a7cae966f3bf81b2fa4b055efe61fa0642b1df46a6edc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "154be5d9eba20bdd928986e3f1003c4abe80db8fe34fb8c5db761aa6d1498a7b"
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
