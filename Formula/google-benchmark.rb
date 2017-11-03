class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.3.0.tar.gz"
  sha256 "f19559475a592cbd5ac48b61f6b9cedf87f0b6775d1443de54cfe8f53940b28d"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd223b9dfaed9208c8c683e933525c46f0a871a3e4bad67b818577f3b1d761ab" => :high_sierra
    sha256 "59851a02622cbb62c485cf9d42a7b364ded70c0b40ce11c133f79195e2ea9844" => :sierra
    sha256 "5052dafe9ca883c844dcf1f85270851d4163d7a2d134b2ebb96a592b30c53590" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", *std_cmake_args
    system "make"
    system "make", "test"
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
