class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.3.tar.gz"
  sha256 "0b88009c636669192baee71589cd37885fe0f39bd24008ccc20780d925c18a2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f4112eba10f69ed9e1fff0859b5d9e9dc6951eef086e83495adefd4d79af998" => :sierra
    sha256 "8f5d9ceb3372ae3e949bc444bc8c413d3f055d62abde12b5a2db0c62ebf90dea" => :el_capitan
    sha256 "1b8eaccb661c1022cd46068f79a1cf0aa77f2fecbefb20371e774577b941006f" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.8"
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
    ENV["LLVM_CONFIG"]="#{Formula["llvm@3.8"].opt_bin}/llvm-config-3.8"
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
