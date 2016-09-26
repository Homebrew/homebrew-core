class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.0.0.tar.gz"
  sha256 "d2206c263fc1a7803d4b10e164e0c225f6bcf0d5e5f20b87929f137dee247b54"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee73fe1a4e7de64eab11db6cffb74b0293456717d90e25aa270f85cce00f10dd" => :sierra
    sha256 "9c51ee80e92c2d530249c7e225bdc23d34581102199ff098a25eb6da7cac7a03" => :el_capitan
    sha256 "e9983f859dcb425ddf670c044a206a971068d0fcf54c234b8f5278873e3b3852" => :yosemite
    sha256 "90f4914562c9ad1678b5e9fa318875cd1c97c098aca441ce58aea3617243c95f" => :mavericks
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
