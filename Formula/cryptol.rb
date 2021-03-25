class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.11.0/cryptol-2.11.0.tar.gz"
  sha256 "43b7535f5cb792efccddbb3f4c09bd2e922777d19a6537cb3aa27adf69280716"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4187c237c543bb46baafc512421ae81e051696fac21f4ca3fd20bd91b5ad869d"
    sha256 cellar: :any_skip_relocation, catalina: "b0a150b50f609533bcfb52525182ff3400b6ff7f35aed6b1a58028730b2c57bf"
    sha256 cellar: :any_skip_relocation, mojave:   "c7e874290c69aea49179991ddcc9c0615d382fe3fdde1c56e8659d3c3f5e376b"
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
