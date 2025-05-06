class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "409075176168dc46bbb81b74c1b4b6900385b5d16bfc181d678afb060d928bd3"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0676c30ba82c95b4c4aea312440390f63d0feaca33ae74779a37750c97df56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b6cdab0a525f0bedd85e42d88c24df6895d74129a0e91d404a281fde8c2e45c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "551d7ade1d078ca9d41198c11b2a4935545d82000c21bba64bfa531de196e597"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b90185572865b582432fbf48a404f26aeb3448dbeeb765e4439e4c262fa18ca"
    sha256 cellar: :any_skip_relocation, ventura:       "d3683500e476bb47bbb3c960552620b374af7fa606c96dc7f046b657b495aa74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e1013d1853765ad47f5d91def16096ad3f5b11f2b50d392845e66b4587bafb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec39d18dae247211ee8a4d9786d5f1c76b7e92273632cbcf2d0ab0d970ca208f"
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
