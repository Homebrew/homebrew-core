class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.21.0.tar.gz"
  sha256 "3a94719e8e7835a97b6d4b67945373346f723c1f85f756a80822f78d9705fd9b"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "21bd726949645b7490e89d337f623136c09f894eea2478a0b322254c59f06a6d" => :high_sierra
    sha256 "6dad266bf5274ee1e4ea6cf67d8a87b09ebc7b2bfd32411722764ca4793f4f31" => :sierra
    sha256 "0cfac2befa56e48c8ff340970cefa3fedb13965a399313466e547cca8fc9e9be" => :el_capitan
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
    system "make", "config=release", "destdir=#{prefix}", "install", "verbose=1"
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
