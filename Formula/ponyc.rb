class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc.git",
    :revision => "5f061fa201b47dc6a767d3bbe8a8999ada66993e"
  # 0.2.2 tag requested in https://github.com/ponylang/ponyc/issues/1029
  version "0.2.2-alpha2"
  revision 1

  bottle do
    cellar :any
    sha256 "59a03fc7a83f5c97262e9a70f383b3105f6d03062aac9ceac4729a6e3a19e7d3" => :el_capitan
    sha256 "c3527fecac254cd94a2f6d42f9418fbd80ca9bf41f46a4d807141516e9f849f9" => :yosemite
    sha256 "38b605078fd9cbc5010995b41327c9161d4b309b0c1696890abf572543f36a63" => :mavericks
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
