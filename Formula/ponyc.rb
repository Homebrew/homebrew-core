class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.15.0.tar.gz"
  sha256 "3ef2e95ffca8adc6653c7bbebd829370d7da28923dc0f5dac2fadbb7e12cfb24"

  bottle do
    cellar :any
    sha256 "d1d3173e79b938217d8a1d03f3fcbd2d0a2b24c1581ceac45f886183fb0ec6d0" => :sierra
    sha256 "e5f66eedbfb69bcab0a604c2e32e3282243292a39125fdab850f776d1e15f209" => :el_capitan
    sha256 "3c6cb45d95aea7431e079ee1e71d234a3de28a1ce2dac7650f4180d83dc99b69" => :yosemite
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
