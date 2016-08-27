class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.3.0.tar.gz"
  sha256 "4b0fa26dd194663f648f8782af79e420bc962281f280233cadecbd9b6cad195f"

  bottle do
    cellar :any
    sha256 "bfc29426072e15b0c1c18be1a8a5acdde5fd3a4ed2a7fedba793d0a6c888d2a0" => :el_capitan
    sha256 "3676d9710ec391755c58b4b059a208567a8a5d52c645a68a2fb0c21474f1053a" => :yosemite
    sha256 "524c99172115fc0a62bd138cfe75489b1b3fd55ebfe055f3dd11df4eb477245a" => :mavericks
  end

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
