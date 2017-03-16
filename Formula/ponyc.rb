class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.3.tar.gz"
  sha256 "0b88009c636669192baee71589cd37885fe0f39bd24008ccc20780d925c18a2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "80921e9f5548d338012285fa221badcf5369d4a0b3b49c2e7e5c35eaa0f47e30" => :sierra
    sha256 "c1d49c6b6c0cdc9968d908fad2ba9630149b71282a15433f13d1dd688a6c4386" => :el_capitan
    sha256 "9f21ba3b13e05f19a9bb56dc073c469335a2b26ba7779c8ea7276dcc4238a998" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.8"
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
    ENV["LLVM_CONFIG"]="#{Formula["llvm@3.8"].opt_bin}/llvm-config-3.8"
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
