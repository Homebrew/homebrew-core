class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.56.0",
      revision: "06a706d4dafe95030f9170ac4417678588bd01ba"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712b7e98a45be1326f98faffaef8d50c3b9dcef34cae856c630c890e242a7e3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a90d8528e9b3c98037ea35e63e0cf86286e08948356e76943ffe538cddf09a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "593a6253ab6bf89a8f86cb3c2a0739a6d9842e83794d7ae7326873e96b2bb425"
    sha256 cellar: :any_skip_relocation, ventura:        "f1a38edf64bf15fadf6c6d44dc6f19583c9dabd39d677dae530bba8a15b3a742"
    sha256 cellar: :any_skip_relocation, monterey:       "bd398b46958d181ffc6ef2697e8be2f44c10ab7cf0dd22156024f211ef116619"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d84e088dcefa991cc5e4ad67ad78ff7e02a7b72eaa1ded1be360c9a7bd1e0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e251fe43aa4fcf9a463f5d34b5eab282afab8f119c39db6526237751460fe0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "llvm" => [:build, :test]
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

    ENV["CMAKE_FLAGS"] = "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"

    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    # ENV["CC"] returns llvm_clang, which does not work in a test block.
    ENV.clang

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
