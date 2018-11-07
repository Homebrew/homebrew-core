class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.25.0.tar.gz"
  sha256 "8420d84f178db325934d77dc407a7f98d6bd14b8cf8036e17b41f886f5820cb2"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "2dae291b0e2aaafb6864b0cc96b04b9c1eab4187dfd55b2f720c86e9c5f2af83" => :mojave
    sha256 "b0d92521cc7b31c809de94b392940ea3c526f21db1c18e384e3e4a1275882665" => :high_sierra
    sha256 "f516cf4cf8d1bdf3ee8c82adf5b3d58184ad0105722b354e851c78b152b1f97d" => :sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "libressl"
  depends_on "llvm@3.9"
  depends_on :macos => :yosemite
  depends_on "pcre2"

  needs :cxx11

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
