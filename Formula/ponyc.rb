class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.21.3.tar.gz"
  sha256 "ef618f80dd793f27293695a3b8dc3a94415838dacf2e736d3d17a655081ac872"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "8a99715f5b17a32146e24705f7f868830897aa77bcb940c856f32ad1f636defa" => :high_sierra
    sha256 "e7c1e0c2d07f0f4e77d8edb85271408e1348dcea18ee5a4eb4d8dd990db92229" => :sierra
    sha256 "e4921999ee11c6a59f774fecc763bb3574af53350b567e38688975acb599c062" => :el_capitan
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
