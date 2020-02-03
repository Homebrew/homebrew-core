class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.33.2.tar.gz"
  sha256 "5917903e17af77b54ae692e832e11078569cecbc24811c03940257a6e9e61f93"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "b810571aff7518d81ea773d07f0f8fd1def25f4c795a664b1c770330d07069a8" => :catalina
    sha256 "2adb6b736e5ed544c6d8535e31f5c7e19b47e6eb57cd34ad6ed3c55b29f619f7" => :mojave
    sha256 "216889f9856cfb4da8bb46a9aaac3af38e4f1f8f349b5928645ea0d266231b8b" => :high_sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "llvm@9"
  depends_on :macos => :yosemite

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@9"].opt_bin}/llvm-config"
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
