class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.11.0/cryptol-2.11.0.tar.gz"
  sha256 "43b7535f5cb792efccddbb3f4c09bd2e922777d19a6537cb3aa27adf69280716"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7864c5659f35ee68c4c84683362063dfb2efd8c143b0bb507fbfc3f67661af87"
    sha256 cellar: :any_skip_relocation, catalina: "be3298c8389c666439fc38f898e4cd16ea06fc3513977dc65a3cca684a28cde0"
    sha256 cellar: :any_skip_relocation, mojave:   "105d72cd5224912dfa83599dbf41393878bc3bd71ce9ab5d8056f490bd18e3fd"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
