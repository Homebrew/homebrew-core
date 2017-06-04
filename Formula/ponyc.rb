class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.14.0.tar.gz"
  sha256 "4a7d05c1b8e6c681c6ee89653b75e0de382176408dc192e3bab2853f812f9dad"

  bottle do
    cellar :any
    sha256 "7684bb5b7a6cb9c1af9f3e75ee1587fae90b855a93f541d14276dcbefa544755" => :sierra
    sha256 "bcdb5927f2c39695680dedca80c5e4e658d7c9d2ccf21b7a16d79091eadabee6" => :el_capitan
    sha256 "882b15cc0df05bee001e44c3b95c9ff77fe554bd8cb8923498ba4071cdae6695" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<-EOS.undent
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.9"].opt_bin}/llvm-config"
    system "make", "config=release", "destdir=#{prefix}", "install", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<-EOS.undent
    actor Main
      new create(env: Env) =>
        env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
