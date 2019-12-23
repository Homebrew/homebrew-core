class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.33.1.tar.gz"
  sha256 "1c7e90e0779f153527dbbbdcd1e409a6d4e1a6ec627000798c1b22f1fcd44d4c"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "eebd0878d40d29f3577dd5e64f2378af43ee2ff6c0efd50b7e4556ed7b076c6f" => :catalina
    sha256 "9b0c6de10107c3a893cb2988e7229fc45b72f834240631cc7e5d8357e31b1e99" => :mojave
    sha256 "6439adc43264925cbf10937d095d8097adb3193b5d3dc06a0b15b367b940d313" => :high_sierra
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
    system "make", "install", "verbose=1", "config=release", "arch=x86-64",
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
