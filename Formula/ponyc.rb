class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.18.1.tar.gz"
  sha256 "18fbfe5e76e742585ad27fd7695df28118d1a4e28c8b221a7dd72f7106115c53"

  bottle do
    cellar :any
    sha256 "1755bb45eaef78f1ef41fb0af36f173ecb77c9d0e923e70ec9da5863959235d6" => :sierra
    sha256 "dba3cb4ea2ba8e68772d2562f99dc01df5c99f88c6863f849772f172b7c9e5f3" => :el_capitan
    sha256 "a2bafc020ddf8450a1e3e4325d67aab3c34091d81e25d920cbd9d60c79c4b6dc" => :yosemite
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
