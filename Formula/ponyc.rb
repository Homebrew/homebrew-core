class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.8.0.tar.gz"
  sha256 "c8c3899147ab7ab27c96dec7ac9de5b6b0683870f12a0f5e60f85762a97acc71"

  bottle do
    cellar :any
    sha256 "9488b98762f351d2763c89d394f10d66bf15671d7d5ef0ce723f315ccde854bf" => :sierra
    sha256 "d3627795700760c1c14314f8d3c011dba83e37bb723ac1e8dd2a4ed09ccfd47c" => :el_capitan
    sha256 "e5954e12395dde17b845f389691ae91308c9d851c0d01b9dcdfc25f23221ea98" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm"
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
    ENV["LLVM_CONFIG"]="#{Formula["llvm"].opt_bin}/llvm-config"
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
