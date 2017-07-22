class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.2.0.tar.gz"
  sha256 "3dcc90c158838e2ac4a7ad06af9e28eb5877cf28252a81e55eb3c836757d3070"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "747b86dbce83cc3b846b1a2dd5564409d8a8778363c5144f01d0c5b9bfc4b0b8" => :sierra
    sha256 "ba23e2238556ac482048ab2b720ead87b1bea0ed8ac58c36707395ee33e8057e" => :el_capitan
    sha256 "2e4cfa40e4c57b6a14c5fef8e93434a901ae4962801bae15756820a0e1144bb8" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
