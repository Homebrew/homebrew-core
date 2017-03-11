class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.0.tar.gz"
  sha256 "cab55c2457c508f807f8cdf1b62bcc492018bdebddf232abc94478d6127e4606"

  bottle do
    cellar :any
    sha256 "fbebe46e066f54949e3f9c4ffec2558701176832f6a20e17a01382235b8b0ed2" => :sierra
    sha256 "65cdcce76a06a45427cf52a94e698761a3a3b567b19e666a8f430f7011972cee" => :el_capitan
    sha256 "1dd21947ea374eb05b3a06d405c3bffceedf5673b108f49069aeaab12bf83673" => :yosemite
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
