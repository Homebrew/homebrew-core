class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.19.3.tar.gz"
  sha256 "1917fa434c34d82f9dd382ac74012fd2fcba4568a0b8d258e4ab1219a84983d8"

  bottle do
    cellar :any
    sha256 "1ef7a4946e218e597a42f6f48bb93e026242cf4d9a7ad27cd19b06331b95e3aa" => :high_sierra
    sha256 "7e9e909a5ce1e9e9025edd14ce7bacab53001b42fcd332549cb0d564be0f14ce" => :sierra
    sha256 "aa73a3849d528592442299d78adebdf5dcc9b6a475ea5599f1eb4b00ea73aaf0" => :el_capitan
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
