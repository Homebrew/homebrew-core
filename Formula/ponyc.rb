class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.54.0",
      revision: "2704bc0cbfc7fd8d63b39d137ee530160d289ced"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f99db7771287ed73885b3bce1c92676b3cb91fe255de9ff70279d293dd18577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c580b8fa85f41b5ba3a037d2042a7541c05d00b8b0f64f41ada7c63ef31aec1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5ba3b91679d59f714b9e6bdb2879870a7274f501655a0560ae84486e13ab072"
    sha256 cellar: :any_skip_relocation, ventura:        "a423addcc6f8801d40ac44352dac0413d4db435fb0b55a770066390a224233e4"
    sha256 cellar: :any_skip_relocation, monterey:       "72c16360876671eba47702d8099992e1579b3db03910552d8d49e2dfec651ef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ac7a090a381490925785b4dfe6eda4aab78a58e0d0f6d6df006365bca74d4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3077f5dd95968426f35fe6f58411bfc34a0f54816e1c4424a40b6bb7ca93bb16"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<-EOS
      .../src/gbenchmark/src/thread_manager.h:50:31: error: expected ')' before '(' token
         50 |   GUARDED_BY(GetBenchmarkMutex()) Result results;
            |                               ^
    EOS
  end

  def install
    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
