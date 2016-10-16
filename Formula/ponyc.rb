class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.5.1.tar.gz"
  sha256 "3d78952ca0912ca1a3b3a6d8c51a87c9bcfcb03666eb9880b76d0f9755843786"

  bottle do
    cellar :any
    sha256 "6774da99c42f2375144f4c69d64b48e97206cca83dc0f49cb50114b7203ca80a" => :sierra
    sha256 "ffb42c42e96f0c3b6a1ccfd4a9c6580fcac0022648ee84e948e31528c6ecc0dd" => :el_capitan
    sha256 "2a2d72940514eaaf3b337012dbb878bb6eff0051484cd1512ece77b0491119c6" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<-EOS.undent
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"]="#{Formula["llvm"].opt_bin}/llvm-config"
    system "make", "config=release", "destdir=#{prefix}", "install", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<-EOS.undent
    actor Main
      new create(env: Env) =>
        env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
