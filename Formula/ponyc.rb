class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.8.0.tar.gz"
  sha256 "c8c3899147ab7ab27c96dec7ac9de5b6b0683870f12a0f5e60f85762a97acc71"

  bottle do
    cellar :any
    sha256 "0cbb5180092132642a994ff5e0f5d5d452c35dfa1502679f0282cafb21e25906" => :sierra
    sha256 "e3bcf4c6b8e5fd9b2c867f2bed276bb67a9e4da6a6f503930a02c55db1153fb2" => :el_capitan
    sha256 "4fb1d15ec80fe11208d5e6d3e85266ff2bf3eea5db8aad3dab8c95987c73d51b" => :yosemite
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
