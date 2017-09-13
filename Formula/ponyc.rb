class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.19.0.tar.gz"
  sha256 "fb10640706b577c844e4236198af8cde9aa0a31e8f8153171d6b48e83ecc2941"

  bottle do
    cellar :any
    sha256 "9f8a96a44be0d1d7bc3a6ad91605919cb79d9afa9ce138c2fa842698ad6c6a85" => :sierra
    sha256 "825e712e17674954fb24ffd0f964cafc5de86fabe962d8410ab9a8078698ecc9" => :el_capitan
    sha256 "be6262841fbeb0f8fdbf73c8e28adfefabeabf03d4272027444f9b43ca7d105d" => :yosemite
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
