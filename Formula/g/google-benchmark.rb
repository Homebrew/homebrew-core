class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "b334658edd35efcf06a99d9be21e4e93e092bd5f95074c1673d5c8705d95c104"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90bdbe5f304cfbe6e77296116f969780d1e475a09ed7fb2e2206c17cf7a36eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f343582dc8ff72ab02342391ab8295e8bd5d6094c4bc874dfd7b9a094cba525b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580c1a3bf6ea70b7d740e6cf86918692b4ae4c6ace20f5b7dd7a98dac489086a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8416e88252420fa06089e252fda1e4e5a4a6052f7f2c305ebd3bfe311c5b4f79"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb289fbd3a461722c35b95cb752be0a991b0c7ae42012e068aa84c8cd42d66f4"
    sha256 cellar: :any_skip_relocation, ventura:       "3b7e2f85d5d7a001195b500cd8ba1d634be0e89163e2d498e4e956f38eb1a4fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb8d0998dc3349707cb2f3c484efcee4493b3b7532a4affd40f4d06f37f9c8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfaf5d515392bcad6dc925796a1e5857d602ff9960d6419883b9c87347de096b"
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
