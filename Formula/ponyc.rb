class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.26.0.tar.gz"
  sha256 "e65631dbf5418abd465cbd5912794feb61c0db9b76b916b39772ad2f623ad16e"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "545b7e4d34a3591b53cd16e321f2d2d50c94045d688aec2e260b96eeb1802963" => :mojave
    sha256 "2cbfcf6953ed2577547fe7db3f7ac23513a658415997ab19f370da56fed6d2bb" => :high_sierra
    sha256 "5d85c1628525faad76cc337b68430f937a3b7afa09da43931bbb60549bb1210c" => :sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "libressl"
  depends_on "llvm@3.9"
  depends_on :macos => :yosemite
  depends_on "pcre2"

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
