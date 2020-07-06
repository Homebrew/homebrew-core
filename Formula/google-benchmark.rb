class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.1.tar.gz"
  sha256 "23082937d1663a53b90cb5b61df4bcc312f6dee7018da78ba00dd6bd669dfef2"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d81d77c351b590b574869d88e22203aa3728410bc1d775f10bec672bf947e0af" => :catalina
    sha256 "ec80102ba3d26ce496a543a5270b4958c25cac3fc72c23f1daceff49bfafc467" => :mojave
    sha256 "407dfc8c6995f34fc9b6fd7da02747d538326462402e744e2318a2db5e3e86ed" => :high_sierra
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
    flags = ["-stdlib=libc++", "-I#{include}", "-L#{lib}", "-lbenchmark"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
