class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.22.4.tar.gz"
  sha256 "cef004f84d5baafd4a94d03d6c8a78895c82e70965ead4b5c9df50601e0b8f46"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "86a94cd0885d6e457e10f695db00d08f82be4fbe9c99a60f4e042d5257441c6d" => :high_sierra
    sha256 "674f75832e419fe077af0b35b560599844257eeac94185d5dec9b34b18ea2467" => :sierra
    sha256 "75250912da49eeeed270574a2ff65d88eefe5aec1c2962ebe2a4baf99d6861dc" => :el_capitan
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
