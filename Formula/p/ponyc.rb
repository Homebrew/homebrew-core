class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.59.0",
      revision: "9a5a2d65b422c2ff104877ad4a0b7048eedba68c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "728c3386ec7bd017a34babadc96370b47a0eb4a9756a950cf0c2acc810bab034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8bfee9875312e88092509e7f45326312f341f99da29d6568e36e96145f1ad39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95f1d38db12a9d94c316bd91cf96d36dfc29b1090dee086dcf56444b1c56326c"
    sha256 cellar: :any_skip_relocation, sonoma:        "92d259585ce0d1fe70c20526a227d73532a7a9547127d5b2ca86cf041a263b3b"
    sha256 cellar: :any_skip_relocation, ventura:       "8df48e6967ddd333b5fbd49498cd412cdbc7026e04fde18e5e740e165641f1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8606e19315e4e90e562865e6f3c9c2e9420c855a5250d1a47b227780fae0c8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0759f7698a899a653162f55a54b7f3d416b3d13f35c28362d9c95d40d50ea512"
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
