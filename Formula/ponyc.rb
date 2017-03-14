class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.1.tar.gz"
  sha256 "5bac06a49940c7be74b8ff9798e39e57bea8d8b549c6dbe61bbf0067a117f50b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c5386e2f1e16e5db26bfa6b082bfa46f031eec3661463b97d823c9fcf6f57292" => :sierra
    sha256 "6ab968f563c7d288289ce1d376f75231e5374f70b6a01ffd9f8acf4c5e6d6870" => :el_capitan
    sha256 "e76a6528d161df2da92d1afa34f7c5294723bf7dd505da24377f4edddcb57f9a" => :yosemite
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
