class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.21.3.tar.gz"
  sha256 "ef618f80dd793f27293695a3b8dc3a94415838dacf2e736d3d17a655081ac872"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "825b974b06dcda96a47b3117ddeaa5f573d5d341299c01904f094d17fcc9e9d7" => :high_sierra
    sha256 "b9b7f047540098df9edc338ad75eca9ed133b630440e3be500daf2ebafe6e0bd" => :sierra
    sha256 "6f37ec3d49cb7fa30f78149bac96ffaf1e461a752b7175507a676161ab1fdb8f" => :el_capitan
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
