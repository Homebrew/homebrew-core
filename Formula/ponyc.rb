class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.12.3.tar.gz"
  sha256 "25338ecb9f64277921a3ec3613c0028ea897b4923e4ca07ae96eea34b4bd8242"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ae1f88fa176f4a4997afc5a402cb45047df7ccd850dfc1650324b4270ca105a" => :sierra
    sha256 "c031bcfeea0b1c41d5f248e607ce38e343152535562a3bbbb03f0b4743a79b38" => :el_capitan
    sha256 "44f4bc8868cdbaf63b836cd2b35176464b04d1f606de64a4a047c2111c0c088b" => :yosemite
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
