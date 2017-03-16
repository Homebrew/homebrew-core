class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.2.tar.gz"
  sha256 "050c778869a4c7477bc93c448149239b6fc40100edf7378747a6368ab2315173"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "bf5df398cc4516066983651769c7ae9d822702708a6a73a74b70e60f0d310e81" => :sierra
    sha256 "4a909887757045311799ad550c881626b984e2909b3e9ae0e7512ce07c24e7bc" => :el_capitan
    sha256 "6b79be670f5cad10225213f05d06d0f52ea1baffbeb8ff2d52576caefec9eb0f" => :yosemite
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
