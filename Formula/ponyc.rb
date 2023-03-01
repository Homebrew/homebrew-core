class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.54.0",
      revision: "2704bc0cbfc7fd8d63b39d137ee530160d289ced"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d8ce728f68182f4816c677a938bf0c83cd9494106a6fd2ab0d1eb3d8dfb544a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c9abac35735cb2ad32c7cf1508a40fb5c3cd6da73e0f577e04b9972217bf0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd048d64293e528c89ee01fed4d5bc9f92df6d29bff8464eb44d4c9a94eff5d1"
    sha256 cellar: :any_skip_relocation, ventura:        "b37a538c0bfd5aa5196627b00bbdf6bde1776c18f882d398f0379b829f867cf9"
    sha256 cellar: :any_skip_relocation, monterey:       "74d080e5415303f411b3d0f7dc59163ab08f930915c60d34a9f353dc659295b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fce57c062870c9e1a380d9685c986b9c77f5464a7a9eefd966874cbd44cb5d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da4dc54cc9026e80e83cb0e020bcab7d69c011feb79c58e49ffc44437fe64559"
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
