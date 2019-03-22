class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.28.0.tar.gz"
  sha256 "4075c1d3848ba128d7c88a83a839215ccdb930edf32d47c48f6b547ce082fbb8"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    sha256 "199b917ae5c5eee23777e56f78a8711283726e67d289707615256a74613b62be" => :mojave
    sha256 "59fa6bfe479cdba949e9c91753775b8c14dac0c691a6ff5f4c7b0c64e98effb2" => :high_sierra
    sha256 "5f24fd0cf1e8ac02e44515b12e3ba85a733d8a527f74cbdfee9f17a22aceee81" => :sierra
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
  depends_on "llvm@7"
  depends_on :macos => :yosemite
  depends_on "pcre2"

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
