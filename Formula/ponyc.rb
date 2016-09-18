class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.3.2.tar.gz"
  sha256 "3110c7ba2519e29b77001a87e676a754cebe3e47ea950e90cf9af0756ed9ec36"

  bottle do
    cellar :any
    sha256 "55e2ff99029a7672c4b98a5e8214a5de8bab8b9774a2e01f1ea7e54d3e056b53" => :el_capitan
    sha256 "6b34bf4549459d77f92ba149942123e445ffec91ca01687f658908081a5551fe" => :yosemite
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
