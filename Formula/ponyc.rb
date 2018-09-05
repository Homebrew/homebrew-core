class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.24.4.tar.gz"
  sha256 "979e443fa27df7b65c3ac35db47fc0b130608f0745d4fa393c451734343c088d"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "3a33eb73400528cb3dc74f20c71cba60cef37fad91b72bf712bb53dc0d17d5f6" => :high_sierra
    sha256 "fe4a4a66dfe058258ad91c0c23ee61c963275f332e9b6f18431ce916ac42c40e" => :sierra
    sha256 "c511daeb62e02b7dd2ccb95ff2ca7b00849d777f5cbfe72e64674d25bf0f4fa3" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.9"].opt_bin}/llvm-config"
    system "make", "install", "verbose=1", "config=release",
           "ponydir=#{prefix}", "prefix="
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
