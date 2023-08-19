class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.55.0",
      revision: "6a1b4c09b62f3ee8241a0376a993b3550efe16c4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a708a961ce34c4e286715370c55bc7ca9ba511bc077945facb9b87fad601baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07ef00a98a3404876b25f4f6e3437da3bb3d7904c7617614b53d8b65389dbb18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d4d93a52d2d86c9db65f693a315437524c2bb746893fcde0acf47c73e4bc769"
    sha256 cellar: :any_skip_relocation, ventura:        "3be7ffa1da625fc06c78fe413e1b7608794324f7dbb279a1c656b7d9b43e293c"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c7caec3325890ebc4f3a28c0b6163bd1d0e0dfcb890b7234246962598e40d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade002ec2c393916f215089d13e8c6cefd78b569782f41acfc8fdd1e8cc1447a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab0f56c6b8a91edf04935e9883beb751bd5ffad15fa8efdfaee446e11ef2416e"
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
