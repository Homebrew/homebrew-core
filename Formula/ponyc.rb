class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.19.1.tar.gz"
  sha256 "186f86e65160b1cfca4d20e149b6b514384f9f3bdb95ac9fa0ab22c03bce293a"

  bottle do
    cellar :any
    sha256 "ead15f50964e1505c1e2953204ffaa61ea64a22c996ba01023f47b05817091af" => :high_sierra
    sha256 "7ed0376e781a6b6eb1d8d7235d67a4ae113caa6ef4c80864c3c1ecf083b4f638" => :sierra
    sha256 "d8c42648fb16bdd4019678c1078969ae5d7fc8d1cc868e46d951313226083daa" => :el_capitan
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
