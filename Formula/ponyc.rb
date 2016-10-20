class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.6.0.tar.gz"
  sha256 "7e0269aa95caa49ffaa07ccfcf4ea1ea372d01ed5deda48a48271e62ea852322"
  revision 1

  bottle do
    cellar :any
    sha256 "05a94810c1ca3818eb3c663367425e50d631b05a7013fac4d8aac42267dffeb1" => :sierra
    sha256 "1260aad229edb53f4c6ca8e41d1fb129e541596633bae365f51f98fbadbe000f" => :el_capitan
    sha256 "7074505cb2578d1d2719a873bb5636b9ac74413a15731bea53f3f9bc2c47e3c6" => :yosemite
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
