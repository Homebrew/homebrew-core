class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.32.0.tar.gz"
  sha256 "e8e070164ca0e4e41e606bde617ccab9cc64aa3dca8c79293635a6fdbcabf454"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "1c9e1e67c63f0ba1a4f26f24822d034063a7b0e61aef9f4bd170286c5ef851b9" => :catalina
    sha256 "78f04a002a09ea593d40ce7de30a55aba15d3938431104453a05bfa7c319759a" => :mojave
    sha256 "2728aae72d8981fce49a080d34729bce4e36f8c220dc5798723b1318a37d7514" => :high_sierra
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
