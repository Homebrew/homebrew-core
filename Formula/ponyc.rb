class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.21.2.tar.gz"
  sha256 "07b8fd00bbe085f97957ebc76add3f0e3fd1c73e847e6b2f2f64d9109a367208"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "8684721afc85eb77db2a2a1438e02d38a72cf03551c7c1c2dc28b589ce397624" => :high_sierra
    sha256 "1f83799ce0a3db1afbb437be44d86c9895e3be6a0f033cb07820700321f74dc8" => :sierra
    sha256 "5622a04b589647360f285defc2b00a73892cb4af2a365f3413670ed239f4fe17" => :el_capitan
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
    system "make", "config=release", "destdir=#{prefix}", "install", "verbose=1"
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
