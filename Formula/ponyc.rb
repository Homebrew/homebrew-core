class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.22.6.tar.gz"
  sha256 "34e7133e95768df4edbf61c6695a2f8f3b9def5fda7c11476cf0c4662c2f8cc5"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "96a02f570306519c63c2766ce6284b4266172142804db65fbe86ce61f55aebc3" => :high_sierra
    sha256 "cdf165a99dce75a6cda49eceb7c3d38a2e12ec237f67350099263163e91a5bea" => :sierra
    sha256 "2a3ca8ebe6a6a43fa72c16c2f89e2549d19b574174d4fdbe2f78c304e22e6a57" => :el_capitan
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
