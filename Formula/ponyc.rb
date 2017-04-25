class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.13.1.tar.gz"
  sha256 "c6be734756451e9c0b32acdcdefebd346ea3dd0bc73c457e4052596e2e9242b5"

  bottle do
    cellar :any
    sha256 "e6c8413df3f83ea019db5f129c3ffae5821eea65f0b4cb100f8be6e4ea4b3025" => :sierra
    sha256 "0e0c25d92c9158fc49b2ca174a7ceba1a5fadbed701fecc193ade170163a3168" => :el_capitan
    sha256 "1efb47718ec4d39652ea0677701cfab1c72abebffe0b97e0099abd508589782c" => :yosemite
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
