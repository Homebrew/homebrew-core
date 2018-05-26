class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.22.2.tar.gz"
  sha256 "7bf1290a4a3f6f74a12482ed1698b45d7766495958f1181e92564991ff7a09b6"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "1e0d2f660903f99c2a6489acfd7a967996c1a862565db33e4703ddc322bdd4f5" => :high_sierra
    sha256 "c4ba6ad43e51fa565cc4007d548cea764319abe1ea5ae30584e90c25e80a39e1" => :sierra
    sha256 "3bb6aafb4ddde6fb1f00162808475fa74bd8c1a315a4157917ee3e23de5eac40" => :el_capitan
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
