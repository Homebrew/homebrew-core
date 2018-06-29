class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.24.0.tar.gz"
  sha256 "840d8fb161c679d20650a80167b43adda8bdb5d7538d9377273e08d9e2d01fcd"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "3a2c0a73823c37db2c99888ef166c9fb7fb936fddd9bda3565a8612af6441904" => :high_sierra
    sha256 "10564673ca52ded9fedbb1ed2d92e0ba418425aba01334e02001d915ab25665f" => :sierra
    sha256 "b757ca45b09f3a8fc72006610546a1ac9f7a7bbf3c35a731e91b167bc6c54eac" => :el_capitan
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
