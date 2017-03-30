class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.12.1.tar.gz"
  sha256 "154543f3f24c39299474ba595ec00e18245edd2b53f97f19cbd77c5fc77cf6f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a82b5e4b74aedb36b52047a7b6ce04355f22000c46d09a92cc4eabb1404bcf9" => :sierra
    sha256 "21ca85ea1d87782aa7f6bd7aad87615209a6695f36d29e6f5c8d25a4fd9f7c05" => :el_capitan
    sha256 "e32ff38990985bc158aa3c1da26d5594b371cfc821a828e4df7bafc0e1dafa99" => :yosemite
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
