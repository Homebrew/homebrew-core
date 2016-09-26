class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.4.0.tar.gz"
  sha256 "a2b5481df5e5ba3b2517e65027f69d83dd54c7e6cd5876508737d9ab7db42c3b"

  bottle do
    cellar :any
    sha256 "5da713b023cb15e89a9b3a202ddc471180fcffec66cd1617b9bb3cef5b02aadd" => :sierra
    sha256 "5c8ceeed69bcf3e741efe792e948e5d517841b1098eac53402b4e8a3e1f365cc" => :el_capitan
    sha256 "ff2103e8b2bc70f5c39e939ea201dfa8142f96089a5ae0d4913677b5bc6bf934" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

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
