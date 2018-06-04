class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.22.4.tar.gz"
  sha256 "cef004f84d5baafd4a94d03d6c8a78895c82e70965ead4b5c9df50601e0b8f46"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "51ea46ef2b4bcbbcb0a84a7452485f7e96117f27e3cde140b7a3ca24e93dad82" => :high_sierra
    sha256 "5a742623f6c89b5f09f9dbd370587920fe1bb3bac593705d16b28b27b390de7d" => :sierra
    sha256 "710f2cf497e564535d7f5ff1eb5a17e37e805e65abc17df51d57ca7c6eb174ef" => :el_capitan
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
