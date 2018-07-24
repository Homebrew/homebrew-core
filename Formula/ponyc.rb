class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.24.2.tar.gz"
  sha256 "903e2a5d3a8f597f9088869a5ffbd7f2357eff5898cd3d21ecf7eb33d0de5e51"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "a6483fe1f763d6ad5e98823f397899882a3e8c93a382be8eb9b7f51ca4d2cc50" => :high_sierra
    sha256 "76576379dcfcc949ee06ccd6903835fe7c31a0d7016326b8a715952d0ec5de75" => :sierra
    sha256 "3ebb2ae857a8a6d6b79398f9efbfa895ff1772939dcfd2c5b3542b3f05c3e5d8" => :el_capitan
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
