class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.9",
      revision: "cabe71ef4dd3d59b620c2b348e381e91d1905a84"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ed1755717a011056bcd1fec998be976a1b65e575d5971cf4cee20610f3c2979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e065f745573c180e1370b5bc552a9be9a9bb9675b2a7c8469fc9c416e2dff72f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01cec72461f9014cc6527a13ffd562f1d6086251b93120c76f81a56b81aa7711"
    sha256 cellar: :any_skip_relocation, sonoma:        "e54d06689c83a3e71c3946ae1022565433365f37c0878559843043aacd66cda0"
    sha256 cellar: :any_skip_relocation, ventura:       "c345120fb40f5fb5b366e3de0806bf78fe241306eddc9c245aca5e2147b9269b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222e01cd8e9ae391b59a840f94135aee3294d912279d994e7246b43d8d37d658"
  end

  depends_on "cmake" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<~EOS
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

    system bin/"ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
