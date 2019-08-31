class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.31.0.tar.gz"
  sha256 "74bb8ccbfc4201e14a2f66502033397d63179f073be04ee366a66d329dd56778"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "655afafb64d7b0b4cdeb03dd4c4d630ce9a2492c3939562eec9024c75182ced1" => :mojave
    sha256 "94ba5d35ffe02c3034c213b12ed5f6db2c1782f06e5d4ff812e0b83b50f8f558" => :high_sierra
    sha256 "847c0653e378ed949248256d459896c875a8d652279769dd88dc1ebb996850c8" => :sierra
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
