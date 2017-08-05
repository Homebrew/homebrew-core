class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.17.0.tar.gz"
  sha256 "a67be46b40600bceb5c550539d4edd9861f7d2366b12e0331d4b6d17924a7efb"

  bottle do
    cellar :any
    sha256 "925f930d19b4b99fd5b654cacebd9f49136a9a15e71d77908d3f9b8cae2614a8" => :sierra
    sha256 "b9cbc94c1ebe650d2330d32623077c29acca9d3cd37ba598f3b7ae487a8cbbe3" => :el_capitan
    sha256 "408694bb9a2c3afcfd401e3278da74c3d618562f5bef5b30e3aaee5d2e848397" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
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
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.9"].opt_bin}/llvm-config"
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
