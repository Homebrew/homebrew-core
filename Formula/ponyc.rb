class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.3.2.tar.gz"
  sha256 "3110c7ba2519e29b77001a87e676a754cebe3e47ea950e90cf9af0756ed9ec36"

  bottle do
    cellar :any
    sha256 "c6b362a5f99671b056838c660cb4467a5979c1fbcbb4a447127bf13e22a2f3df" => :sierra
    sha256 "70ec61c66d2863c559307b42be605f1c8e65dc70607f02ed4c12d5abc35dba87" => :el_capitan
    sha256 "93d43c3485beb717990c3e294c9eefbf2638fb80b5344b9ce958d6a0972b58c3" => :yosemite
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
