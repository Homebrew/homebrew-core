class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.45.0",
      revision: "18c59df20206e34ab6379e31fb2d75d762b4ca6e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33273abec8d3c27b81e8303889c074ff44219609967d034d1557b94f38fbdc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b45cb38676e5520ac8a83190280ece575ac01eef2864709ebb3a29b256dacaa0"
    sha256 cellar: :any_skip_relocation, monterey:       "e15fbbe1eeea80465ac224c29336b132d7e10acb7c32bf2dd171db61e3e5dce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "11680dcf123d4a3e3afa00590e53482b81849896f0dbf5efb9d47ee9be620ad3"
    sha256 cellar: :any_skip_relocation, catalina:       "990274231567328cbda03b306f1d8307570bda398ea7bbc2c3b6bad7d0b56bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b931330e95d55c1be08c7d8d13431e3556e1875cc866c1a9d328a3ec32ecdfa"
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
