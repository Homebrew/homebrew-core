class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.29.0.tar.gz"
  sha256 "9e20afeaf46343633fc93f995a15a62acd01b42943050c7c282381e4a0144241"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "69c130ff292dbbd024ec5190161335d764ba59ad420c56f2fdbce19d7a7e7547" => :mojave
    sha256 "394688213f88f6f571148af03198a9ca6b6cfd75c15a5e1bc8bc352333575c68" => :high_sierra
    sha256 "6c4ddb7447560b2ab82ff0f0d1f680485a64923b3a47d37e6070037b3e795d4c" => :sierra
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
  depends_on "llvm@7"
  depends_on :macos => :yosemite
  depends_on "pcre2"

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
