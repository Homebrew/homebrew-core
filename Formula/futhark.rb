class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.14.tar.gz"
  sha256 "9b0e10e87feddac3e1ac4d9c1ee285c2be18e8bf57a841a968d11b938b17d6da"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a40786e114125a7ea32a24b36311ee766a003b392a65b70a1f7d5ca933db57f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d7a580c4b2eb5c8acd9661ce196bcfcf8fd5bb55cf458d8ee5b2286a986e7f2"
    sha256 cellar: :any_skip_relocation, monterey:       "2f84eef9d562af3dd8c9447f8c62880cf99153b06b53d8fff0b3297a3c8aa1cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9dd701e80e755ba1ba2725f17460a4c68d9eb171f2bc4d4f3ecb1e2dad53902"
    sha256 cellar: :any_skip_relocation, catalina:       "0a621a6a493851480ef699403970d1aac545ab46c81704649869a897179a4760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d04153a601da2be42d3589ef0c2d9b0eaa8d2126e9c990c0e8d717dda1b1db"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
