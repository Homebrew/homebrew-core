class Acton < Formula
  desc "Safe actor-based programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "e58487e8c5b17a669080714a2b9940e02f2e26c86e7a549b0fdcbde92ea866ae"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  depends_on "haskell-stack" => :build

  depends_on "protobuf-c"
  depends_on "utf8proc"
  depends_on "util-linux"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  on_linux do
    depends_on "gcc"
    depends_on "gmp"
    depends_on "libbsd" => :build
  end

  def install
    ENV["BUILD_RELEASE"] = "1"
    system "make"
    bin.install "dist/bin/actonc"
    bin.install "dist/bin/actondb"
    prefix.install Dir["dist/*"]
  end

  test do
    system "#{bin}/actonc", "--version"
    (testpath/"hello.act").write <<~EOS
      actor main(env):
          print("Hello World!")
          await async env.exit(0)
    EOS
    system "#{bin}/actonc", "--root", "main", "hello.act"
    assert_equal "Hello World!\n", `./hello`
  end
end
