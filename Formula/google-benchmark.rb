class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.7.0.tar.gz"
  sha256 "3aff99169fa8bdee356eaa1f691e835a6e57b1efeadb8a0f9f228531158246ac"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e97eb8c774a7aa2c7d79c7e626988dc306eb3c9da81cea51fe76bb26e7036c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec0d80e5f9703421253aa6c1e838435dd8e31e13e3666553ed8c64936e172a55"
    sha256 cellar: :any_skip_relocation, monterey:       "e63527fcd116205e26877d0e68e3cc1c858fa0381850123ed5a20deb8e25eb63"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2141e0f4b123b3687d20b13b7714793b277bcdf9b43f06b7c6172d12c14a97a"
    sha256 cellar: :any_skip_relocation, catalina:       "29f9f73b7bf64210a2a0eec970b829d2c4d60b65c3f328f19772acf073f21337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c12becc083c1888a93763121ecf28985a6a4ea94ac1e41ab5e39545c4403f4ea"
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
