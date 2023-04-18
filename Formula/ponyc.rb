class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.54.1",
      revision: "297efcef9f3b7b17b7b2ed11c3ed7365498d6637"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af9e2f7f02b6b1f7ffce4aae5d61690538bdbc47c6954a8805ccce6864bc9f2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83adb95decbfb83a2c3d942a3d5b24e2d07f34e5d5c5da100c7d9a552741e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b319ed192df77fe1543fef8c4cfddaa874ce9091386c9d7d3aa4bd7996a53d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "368b3adb0dc0709a7a82647b329ab65765d056b275a1e848cf659a16e03ffa0b"
    sha256 cellar: :any_skip_relocation, monterey:       "efbaf0856d44a1834c829e7130bf41713f23f00808ab8047c8734b8bd508174e"
    sha256 cellar: :any_skip_relocation, big_sur:        "de2c134e19b5d43b17e0a979b1f9f387ea3a272d4644e4efe706de0134603429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7475f9b52c9451774578e0f9ee670be43aae202ab76969416ed72c3e197a215e"
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
