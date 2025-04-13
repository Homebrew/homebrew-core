class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.13",
      revision: "fbae22329109da921ba57614e2aae77a5c776d99"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c555d43672fa143e7aef6b477236315be0b1fcf7a0103641903d4b49c130fee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2b6a4a411f13a91366aa6b4299ab3dd8e599be8ce0ed4b78cf9427dca90bed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42effa3a3be2b6514c1a464359f0b34573e3063e510635d7fbc15e26c425e7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8db4eb7a97ffe5010a0116a75fcb6e8700d5dc7d47874b8a62757bba8942bd0c"
    sha256 cellar: :any_skip_relocation, ventura:       "c27dd9b385726c4f9a917cf8377b2c4539188c0eacbec1144cf97bcd6d2fd86f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa6233a76b2d763cf313cc94894eb1c65d630095951d740e4b18379c4aa414d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b893acb2605a07e6a2f85f2a8a9f40766ab6ff760b41fc71ee4bad4995ae6c68"
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
