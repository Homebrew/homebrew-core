class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.7.1.tar.gz"
  sha256 "6430e4092653380d9dc4ccb45a1e2dc9259d581f4866dc0759713126056bc1d7"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "030e972223107283b18bde8441ebd4b5bec789666ee2186c7052618fd9887e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a10bf9895f453e8632baf892a33c8a7a95e1904d38ff900648042e73fff461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "139bc62b9a65bdbf5c6c9ea1055469257e4cacf2b8a8d80b9a4d089731a70a17"
    sha256 cellar: :any_skip_relocation, ventura:        "403c232eea67151d0ac32e4b543b8054d32b922af54ed65ed3e129b6099a1d81"
    sha256 cellar: :any_skip_relocation, monterey:       "a2ca9e5cb6ffaadc99aad1d458f5302564a51875c1f3aa26a88a7ba7ee14f2e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac57d10b5c15317b923593776dbe5306224e5761959b91a16044f981773a3ff"
    sha256 cellar: :any_skip_relocation, catalina:       "115a907dc638cac992f4297ff71415f00f645a95611c16768a1783170dc7a1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3a0b2a03effb813bfa0543d78622342cca20deb642996c22b032c9008b8a8c"
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
