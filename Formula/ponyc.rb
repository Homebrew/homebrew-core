class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.31.0.tar.gz"
  sha256 "74bb8ccbfc4201e14a2f66502033397d63179f073be04ee366a66d329dd56778"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "1e31b7a35c59af6641c7efe49f9b2d1cb171410c3d5afbe75fe0a559c5f5987d" => :mojave
    sha256 "eb7677788987281f1f2032b59ef4cd5e5fa01896e79b346638bdb6fe8a8480e7" => :high_sierra
    sha256 "3edc0fc29683d3e6d1143c73ac0508d8beba49a499268d876b2cc8671d1959d7" => :sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "llvm@7"
  depends_on :macos => :yosemite

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@7"].opt_bin}/llvm-config"
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
