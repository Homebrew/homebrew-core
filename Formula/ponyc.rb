class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.9.0.tar.gz"
  sha256 "0cae437e66ab028a08a658278635dbc47e6e541d7b7dabe3bcfaa035126fa3a2"

  bottle do
    cellar :any
    sha256 "280739d923420fe31c43cac335c3c26ae46556cf72690406d7d463378225727a" => :sierra
    sha256 "50a6ab7bbd7cc334e2251675f98df03c072bd47a3ed799d1e15f3d26ae0b30aa" => :el_capitan
    sha256 "9e86f71f21916c6dc00e5b3f5abfe7c250166b56bb408c9af5d19cb30996b2d9" => :yosemite
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
