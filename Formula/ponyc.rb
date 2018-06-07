class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.22.6.tar.gz"
  sha256 "34e7133e95768df4edbf61c6695a2f8f3b9def5fda7c11476cf0c4662c2f8cc5"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "7b0bad83780d2ba3de7eb2faa9e5545b25f188c98126dbe9549c4aa792ed1f31" => :high_sierra
    sha256 "2b27aac8808749ed3940c3e865799a7f2e1cd2eea2e5ef3ecd2002c691e1b930" => :sierra
    sha256 "8d602dad73b677768acc2ddc65eb7fc36dee816c7624ed2dbd1deb3258782540" => :el_capitan
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
