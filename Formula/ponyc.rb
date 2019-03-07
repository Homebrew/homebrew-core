class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.27.0.tar.gz"
  sha256 "52afc7b2fa03e97b1e6535ccf78c2811df15fe8e37247f32c4b8cabd1b638448"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "50d5c8622b9660725ba5d8dd00772e276f6787bb15c4d11296dafcf45f942768" => :mojave
    sha256 "03c5889b999c33b32c29de5bad8b94f51eab4d956f5c4f133cb7cfced8c9ff1a" => :high_sierra
    sha256 "cd44b41f87be53a1c65ab3387d889cc3a54821d00641dba90959dbaab68a0705" => :sierra
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
  depends_on "llvm"
  depends_on :macos => :yosemite
  depends_on "pcre2"

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm"].opt_bin}/llvm-config"
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
