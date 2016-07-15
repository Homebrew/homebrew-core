class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc.git",
    :revision => "5f061fa201b47dc6a767d3bbe8a8999ada66993e"
  # 0.2.2 tag requested in https://github.com/ponylang/ponyc/issues/1029
  version "0.2.2-alpha2"

  bottle do
    cellar :any
    sha256 "0334cba03d7c3bd17b8c91429abbde308b821868287d747c34cf985477f4f1e4" => :el_capitan
    sha256 "2dae1d035c593d1483420b8186bf767b0f3e11e9956c3cd55145f2dfceea262e" => :yosemite
    sha256 "321006063e24e196c834cabc358b8872773cab743962ad0b75ecd559a6892148" => :mavericks
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
