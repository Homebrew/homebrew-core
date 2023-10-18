class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.57.0",
      revision: "4bc307ffaac9f26375e28d379ccf7e31cef3ff3c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f706cea09b2b2ae475c2e1a03eab4b269f15352032f2232e599ce5fa11b0c5ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14d1f58e432bf7e3f9748561de7167942c7dc674fe3d9fa9a2b4465af969824e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e17f2a7b818fb7613eb9cb877b6265d8fa3f0a2f5dafb5de32633b01d7042c"
    sha256 cellar: :any_skip_relocation, ventura:        "c8ecec13e17fe31605df664841f08e3218ae9a71a442f83b2379f5413c527a6d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4854d7f819f39664923abc77c12dc718d38c0ec7f8bdf483f3c10686a3411e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c92dade12496339e9e7e4643e33728eb73598b407c152f437682ce105f0138"
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
