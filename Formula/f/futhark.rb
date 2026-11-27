class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "2aedf46914f8004f86655eb1c70ff5c9ebae116bb5d627a57133aa84f5b84cac"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    manifest_sha256 "34d226cc037222447d95747f7712a65b5dc63d10103543045b6a4c89e93b7010"
    sha256 cellar: :any, arm64_golden_gate: "847de033388c2e19b42bc702e9b36c912299e37cedc171f1e3737693e5bd6b4a"
    sha256 cellar: :any, arm64_tahoe:       "72a45494298403239c46f41832264fd4aca619f4ba48cfca9afcc6440a2eb985"
    sha256 cellar: :any, arm64_sequoia:     "8155f95e36fa7d80a83595a72f9bfe6b3394778099a2d3a15abca195d1d21217"
    sha256 cellar: :any, arm64_linux:       "ba1c3596a0a87ac2cdc1f916d58f43e8706609392e7adf55bb971f1ac20e1f75"
    sha256 cellar: :any, x86_64_linux:      "0bfa5d5bc610b1e5477d0e110fc20cfaa9a770f4e30abadebc40cc4f002e48bc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
