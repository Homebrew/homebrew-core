class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.13.0.tar.gz"
  sha256 "aa4273a221ad3a188f4d4d2753e6f78ad2640a3650f22f4ea610a0368df04eec"

  bottle do
    cellar :any
    sha256 "455413d44a03c1b11ecaabd0fac70ad0bc68dbfd343e55986a37926490ee0a92" => :sierra
    sha256 "85ce376d6d1a458b6fc8fc50a2e3082a3954837c9af9d80d013af5b357401ec1" => :el_capitan
    sha256 "9c06d88b05533fd9c7dae5d6f9904d74e04b9c0f13aea0359f1654759673980e" => :yosemite
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
