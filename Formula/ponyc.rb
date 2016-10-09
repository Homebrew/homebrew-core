class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.5.0.tar.gz"
  sha256 "f40543290de5e2f19d80360e1a78803b0cb14c6899ba91f4627e2e2ca586d88f"

  bottle do
    cellar :any
    sha256 "89b24cce7e5ade7cad0578d95f0f2634b95df364bef378445f025d06a059a7be" => :sierra
    sha256 "118905f1ae89dec4a5285f85fb3cd032732c61554dcdc3aae46bf90913cd2111" => :el_capitan
    sha256 "6bea2eba81c1212d2775e46a6e37db2c87ac339fa25889bcbaf79e42cc5fbca4" => :yosemite
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
