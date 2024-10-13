class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "35a77f46cc782b16fac8d3b107fbfbb37dcd645f7c28eee19f3b8e0758b48994"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9658171a134ae6831708b71822209758d02d2a327f971fa5ebffd99df1ea4150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f46c9be01075480e76f7a6dfbe4efd44e81be125d0b3128e059e41cc47ef37a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db90320b93d1add0184a40b89a56dc2506bcf2a2e7e55d6a965fa26f319e4867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "635245e327d4675ab5ee6774a782fb1ce3e4d6615e1eb0b10d6320798df3f4e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8e7cafccef35ebddf6d89d12d5c02f3caeeb9d1287a12c18dff7d961472e940"
    sha256 cellar: :any_skip_relocation, ventura:        "8cd9f07a6d9a4b88162d60e765860f2a9b5ca18f7e394c58408c7c1d5d05752b"
    sha256 cellar: :any_skip_relocation, monterey:       "26903c86cf00cb8e6e743a27e4dfe9ea534453818a81305b85fb1b515d44bfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812f668c5be5c47bf2c327c589714b139780343d7ac1184903a7681f21b642e2"
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
