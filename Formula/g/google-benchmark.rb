class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "32131c08ee31eeff2c8968d7e874f3cb648034377dfc32a4c377fa8796d84981"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640ba4c9e992d27b80aeb54e9cabf1d9386c230440940ebdf02e8f7db09713a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c9fc96575cd6f7e7241e359df03a9dbaffea569c160b0cab81d54aa9593e352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89a1537bc5004572aa0277a5c113e3907b4453b0ccf15b4c0d980a70c5afc117"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e63378d17e3a72b1c7a198a61e74ca823217edbb1abf080ad64d093b107a699"
    sha256 cellar: :any_skip_relocation, ventura:       "bf91cfbe179fb24d2c297fbc87d01e028862340b82a94b9018e59e1f3716bce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a44839b256fd772353566f2cd8a73266e90a72da964454730481e62dc020f4"
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
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
