class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.17.0.tar.gz"
  sha256 "a67be46b40600bceb5c550539d4edd9861f7d2366b12e0331d4b6d17924a7efb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "03bf7befa6095c8b6841cc813f9ec4d670da238b6895eed1816e2989184df27a" => :sierra
    sha256 "984c501e957d0229775c96aca6c2a4421757c969d6f91d5d01ea7bf5d832d94e" => :el_capitan
    sha256 "bfc5bdadafae985256c67e02193b358f39ceba8afcfc19b7b91b8fd54ef356a4" => :yosemite
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
