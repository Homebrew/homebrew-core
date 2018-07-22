class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.24.1.tar.gz"
  sha256 "2130e2415ce25d4c3399d273445f569959701bfc53b12424bcdaacc3674a91f6"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "89c91241aaba3880827926b50b0e03d6467563e506537c4e473d9cfd6b58b087" => :high_sierra
    sha256 "04281656fa85b7f600ce476f1bbb63da24fd0476e31dda9af3048ac13f587830" => :sierra
    sha256 "026068f870513b3f349bae39848e78bae0e438720cddcfe87f7fea449fffed17" => :el_capitan
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
