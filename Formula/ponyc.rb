class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.24.1.tar.gz"
  sha256 "2130e2415ce25d4c3399d273445f569959701bfc53b12424bcdaacc3674a91f6"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "031963cfaeab2b8e174f84dd034ff41b3c55272f56f69ef38e9caa07ee012950" => :high_sierra
    sha256 "b73f42693d74b6d74f5bbd3ebdda505dd441047621dc3dfcf88f644ca76ee952" => :sierra
    sha256 "a371493307cfaf9abb7b355a08ad68a70474bd865ce66c78df290abd7b746903" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.9"].opt_bin}/llvm-config"
    system "make", "install", "verbose=1", "config=release",
           "ponydir=#{prefix}", "prefix="
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
