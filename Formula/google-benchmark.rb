class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.6.1.tar.gz"
  sha256 "6132883bc8c9b0df5375b16ab520fac1a85dc9e4cf5be59480448ece74b278d4"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c03524e82c56126f86ca6740a46183f5f726a8f97ea0464dca1125aa6a4343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6c2cb648a5de80cb70553bd6efb0d1450f300c7a5a6c25d84f3536e6925da9d"
    sha256 cellar: :any_skip_relocation, monterey:       "627dfdf6e7ae9e020c1ef09fcc7d83180a4258d65d3957a1a621362e713949c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6895756afa835ca89843ec24bdea614ab34fdb20d33ddcd864b6dbb063ade39"
    sha256 cellar: :any_skip_relocation, catalina:       "86aae7890ad973abda30dca7c097c31bc643ca9c5ddad9b49ddc6ee8d1b57867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2630432d244fa03c2b5574e831b30a3bee3decf846df2483c3b060608db671c5"
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
