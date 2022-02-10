class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.48.0",
      revision: "367815b900a914ee385f958452e07f6e046ce00a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c8f81baf0dbf4539bc6dda139fd46a5a70521cc739f9b2507d1c730c37b36b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b9092cb374423746b3b1a4fb1449ce8a2b0d652c507b582a75d4862a74a7b2b"
    sha256 cellar: :any_skip_relocation, monterey:       "54fc22099af71cb7dd8f31017a2a2ad0f4c0b320852632e3e2368553aeb1b8e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f3806405fd19e372ebe2c277b9a88932f52182668b8f3f07a9e6d68a5e3d0f"
    sha256 cellar: :any_skip_relocation, catalina:       "40610701ec8983ed84108be8e41ecac49eafacd495a6cc1782d87dd10cc729a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e960076f0b3b358ea58d9e2a71e03c12f1c947fae0d25f66742f7d7409428c"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
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
