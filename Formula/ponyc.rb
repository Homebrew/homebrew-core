class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.6.0.tar.gz"
  sha256 "7e0269aa95caa49ffaa07ccfcf4ea1ea372d01ed5deda48a48271e62ea852322"

  bottle do
    cellar :any
    sha256 "12055c806e494072234111612bd7d4f0c2168c52d199dcfbc3dd5cc32152b2ad" => :sierra
    sha256 "cdef89e90201c307bf84bfe4400581ff98ba2ceefef1ee640a97a575749e032d" => :el_capitan
    sha256 "07822f6c10cca281f5dd67aaeabb33afa348d9b8feb704020e58c59b336fafd9" => :yosemite
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
