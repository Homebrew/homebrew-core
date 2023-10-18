class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.8.3.tar.gz"
  sha256 "6bc180a57d23d4d9515519f92b0c83d61b05b5bab188961f36ac7b06b0d9e9ce"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "645b8944295b33279cfa7464992f5fe3f13ef10a49a111428ff1546d29121c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "708da5a3e18b29ed93a0eb942521e1033ad137482b73494de8fa2cc66359aa73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1484ffcd4cc84cd253cf2526bae7145fe70ae5ece7140409b6157bc2d63f73e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "234862310e242aa2ab9ae92c69d831a51608a4a47aff0bb1073d4a596f162208"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a6d054ccc2fa65f99516eac71114303ec554450ee7139d7af16307d441239da"
    sha256 cellar: :any_skip_relocation, ventura:        "a0b6a7565d288b162ca6d20b35451a25d2c187c90d0352079239a3bdc9c56be5"
    sha256 cellar: :any_skip_relocation, monterey:       "447e907557a4e96583be9359780b594df22105bcbb0b21ef02d924db63aa3c6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e956a31d8f4a7769f438935a83548f5072218d8a8707e344ab0db655bd393a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6923ed936f3b729658b58734b3ec766fbf5c9074ab1acdf0670186fa8856c41a"
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
