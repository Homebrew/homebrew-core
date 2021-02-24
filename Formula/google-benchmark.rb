class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.5.2.tar.gz"
  sha256 "dccbdab796baa1043f04982147e67bb6e118fe610da2c65f88912d73987e700c"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1be7c8171680b473a0b4175be006e5c524d76ed165305f347b3b7de8dd3846f"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d488749c931d730a0d074c01b288c579c89083c9f49760e8ce451acf84ea0c7"
    sha256 cellar: :any_skip_relocation, catalina:      "432e4f98bad2a73d0f47279714d5028dfad2283f939eb745794b47272bf90f2e"
    sha256 cellar: :any_skip_relocation, mojave:        "e303f9f7f9ce196aa338a18767605162d27612514cd134e7b143be0b85ffe66c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8275a82eeb23188a166f67ace983ee9968f247840d20fb0119a5f1c0f5067c7a"
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
