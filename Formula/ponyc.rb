class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.4.tar.gz"
  sha256 "709a70854a9408985371c949c1c5f8002210b1fd6b9b947b68b5fa7d9f154cb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fce90dedcef838ba065caf2962b9982e193dc0f021ecac15a0a4b4a599b8680" => :sierra
    sha256 "2ae598e71c41a822d12892cb3c73ffa944b7dcc151a73efe6f4a06c8c212b0fa" => :el_capitan
    sha256 "418bae1246b895ded8c57fc0e3139cc29ee4c74d6ae575c2b808dc7d5b321286" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
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
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.9"].opt_bin}/llvm-config"
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
