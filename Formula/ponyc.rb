class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.51.3",
      revision: "b9de0c0d5595343498c4fcaa9dddcc4724adea8a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95b5306543275d311f6d97f67f972bc15e78b54b4fc01c7e193269725b86485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "001fd7651c0a18d28ae2162d03bd221def53b57815458173dcbbb11979131d6b"
    sha256 cellar: :any_skip_relocation, monterey:       "4eccc65277d78ba298ad91f718382da2de5c01800e947b089c7d95d93438bad0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e05c0e92fc6f709f488f31b37e78c7a1cda50bb149c5b3943bbd6063f2ef24db"
    sha256 cellar: :any_skip_relocation, catalina:       "bf78f834653a46076adbdc50c84aa47c89e07ac0ee6ab8ed40300e3bd87eb7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1432cbc9ad1f68dbaf54f54c46f88033fb05d0e4203fa0e3f137f6a33fe3111"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
