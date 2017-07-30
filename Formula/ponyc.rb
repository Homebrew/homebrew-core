class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.16.1.tar.gz"
  sha256 "4004d7efb92ab72b84d390d1909a763ab618b7ae842b8c986013333e48c4e8c0"

  bottle do
    cellar :any
    sha256 "cb4356bc4ee73d26f4909206fb84236b89ad0e2facc48338d4a0ececf6f854e9" => :sierra
    sha256 "2f1919e9b82d321d587a0ba80057de300646f0c7750b6dc9a3cad9523a914bcd" => :el_capitan
    sha256 "b4d26558e3376c6fd53d7643bdeebd843849e9821d746fed1abf92ae1edad46f" => :yosemite
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
