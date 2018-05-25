class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.22.0.tar.gz"
  sha256 "26b51bd3cda76329ff6dd00ccb3f551c9c66f4aeab8afa276b215cb8a1259f21"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "b7d614473b664251a4c7b53def9ecaa77128265977d0f96d8010018672b08e8d" => :high_sierra
    sha256 "102d4bf2021d9b6e3a5b192586f566d9bd3d095700bcecfd4a27b03a0c073c24" => :sierra
    sha256 "463e64a8e186b8bb2499abd8c247a26c8887b18b58a0381f76402d122601b286" => :el_capitan
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
    system "make", "config=release", "ponydir=#{prefix}", "prefix=", "install", "verbose=1"
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
