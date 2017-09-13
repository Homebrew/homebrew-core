class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.2.0.tar.gz"
  sha256 "3dcc90c158838e2ac4a7ad06af9e28eb5877cf28252a81e55eb3c836757d3070"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09f5cfd1d37193d92e42db89706ac1fba807168c1e4bf395d3161eeab01bb988" => :sierra
    sha256 "f2207abb422e2f0fe3456ee4d2262dce77c4764d726f6645810e3bddf1b259de" => :el_capitan
    sha256 "b29fa824aafc822f769bacb558da8e155dbe2d0f121891951a15529ff1111746" => :yosemite
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
