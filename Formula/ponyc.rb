class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.1.tar.gz"
  sha256 "5bac06a49940c7be74b8ff9798e39e57bea8d8b549c6dbe61bbf0067a117f50b"

  bottle do
    cellar :any_skip_relocation
    sha256 "49f8f3d40ca13a8713c4be445471d21970d672bb1aae1924e49b3526aa1420ca" => :sierra
    sha256 "e0ef7ec8da6ffb0ed2bf5830ec86c17253da15b93f0e42ecedf24ced3dcc409f" => :el_capitan
    sha256 "a01357438f259a24d473a2a47855df6b9dc6bfdaa6f86635616b81a01b475b2e" => :yosemite
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
