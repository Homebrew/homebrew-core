class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.43.1",
      revision: "14edd81469d3c4e4af9dc478911601cadf785502"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "86d30578e51e294be0d6b20e4b145ec138a8234555771e675d7d5ae123d3a431"
    sha256 cellar: :any_skip_relocation, catalina:     "4c167edc07f753e2a118575d4cc3146949fe907993e26fd30ddf0a3ba3d1a8f7"
    sha256 cellar: :any_skip_relocation, mojave:       "b4a829497a0e202e44640ec71f96ddea2358f518359c95cfabce33a6a0195fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19f2bbdaace1fe667065141d58e12ad0fb6291325d01c89a20ddfff2c6afbf1d"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    on_linux do
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
    end

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
