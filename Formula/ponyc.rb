class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.30.0.tar.gz"
  sha256 "9f78f4e7cd7965d46818db84a2ab4d3f5891ba10f16bcb189496238f503e6009"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "a6da68edb5aad4cdb1e39bc5c6509e9636ed78d4faf432b4b825463efdea30e8" => :mojave
    sha256 "2d63624c18fb2409b260f954f66f48f55a43d8c33c5b522b69d6ddedfe726b35" => :high_sierra
    sha256 "21b9bd000ff7d3859b1e68d13dfff75a123df121ee1bc711ec538a02124c6a76" => :sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "llvm@7"
  depends_on :macos => :yosemite

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@7"].opt_bin}/llvm-config"
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
