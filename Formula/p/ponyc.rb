class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.56.2",
      revision: "304d541628402c0fa0d84b0b02ed5427011cef1f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c74d2b4732cbe6ef39f29983ae54969032528185608b1b8e84ca15df53f6a37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2587d78e272bb8aaa16b3353016eadf5f8050dee308121dc2d5b5408fb09f167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3875bad63e59ac0e8fcf994d3724ac75997ba85cad73a2ce519c14017fe57aef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82aedbd52946245b1adff8c3b3735e1cf26421c8b0deb3ff0ddf29ba7cf48573"
    sha256 cellar: :any_skip_relocation, ventura:        "de336ac3332a935f050b7d891e8253e7cdf1ca19b8814bf5952c169236d2e9c9"
    sha256 cellar: :any_skip_relocation, monterey:       "60306bd8f22a615014bbb03c3c6de8133a513530c31477d826f84c7815d44f0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f488483670f33ebbccbd3c10dc850cf02c717d832bf3ef74cfcfed75d8736fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "220b90786f560125e985a87374c0c391d862da5bbd23750f26889c288afcfdb6"
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
