class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.10",
      revision: "3caf61058a66b66b90777ce6b403ddbf88666484"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de18c77b439c842d3c1bb2da9b02f7387a537f417b0ce94f9df02a795ef9029c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "955c628a2e4cec88304b8f59f2d5a4e59438dada279c1c2fe03e5c41f4cb7459"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ee6d51ffde7c8888ff896319b6f8087e9741d7884126b716e46ade8e9dcb18d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c4c15e40317ea49f248aec7f6378ab229269e4663d34bdc0da0d4128047a0a7"
    sha256 cellar: :any_skip_relocation, ventura:       "8828d1a656755ad531fb63bed0984b9c0221c103fef48c5d5b9bf13705034a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613fa57a9d01c798ff28b1b397c201f097c55d9db4aaeb92e188c8b0456fdc90"
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
