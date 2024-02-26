class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.2",
      revision: "d65cf342588fe4adbacf77e77efbc40cfd9bd5af"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42c75200a706da9185691874b00beb741c2b91d2cf7c08d7a4974b589f091018"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c91573027416b85e002a7c954dca10103f0cdfef98ac9a8e746109d45ea24bfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "029f6e448d96d757a296ad68beeadca21c9ed97b1df0f3b66b38f4d31e4d3fa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b20e15651dd369d278d5b0df40c8eda44cc001966a8f64a7758082269efb9ebd"
    sha256 cellar: :any_skip_relocation, ventura:        "7189a74dde1f74c3b1c32f6c6940eff09eefc3520109b0d995a316eae91d91ef"
    sha256 cellar: :any_skip_relocation, monterey:       "c1e59a9cf600e369ca5482ba1f21d5e165fff564924840e41272095fb7484b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6868aac1abf1c285f459299ab736bbe18602cf6b901b7cfb74cad82602e012"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

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
