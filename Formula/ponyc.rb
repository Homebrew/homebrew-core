class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.33.0.tar.gz"
  sha256 "e0bda6ba9d6a1f310cef1f3a223b804af454849ff005a437d118232fc7ebd55e"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "f775c7315819d237b4da5818bd652b74f9df41e8719012c07a69a9b41deb02c3" => :catalina
    sha256 "acd5a5415556fd8398ba270feca3563c902294131ea7c7f166c7eaa48188cfaf" => :mojave
    sha256 "2163008fe068fec8ebe33395363618bf2766a11c8cb4a4464d993e1f18578d1a" => :high_sierra
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
