class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  # TODO: Try to switch `ghc@9.6` to `ghc` on next release
  # https://github.com/GaloisInc/cryptol/issues/1624
  url "https://hackage.haskell.org/package/cryptol-3.1.0/cryptol-3.1.0.tar.gz"
  sha256 "f2590f15b0119de5510eca2d02a58a399771bf4224f5a3cc9b8ec90aeb050b03"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1be83ca0be77a60bfcf7a34c7dc0d13e1fdd54b450dde449c0f15329ba949dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ca83d6fc539c6e18d9c2b58bac75989aae2ddc23953435102cc33c1a14075d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22388ee60dcb8763aac086a0a832ea43e698aced5856d3947d4f8b8545405869"
    sha256 cellar: :any_skip_relocation, sonoma:         "17f366d8ea5018ca894f9e49954be47b0c5914e354ca2d0114abb6a45578884a"
    sha256 cellar: :any_skip_relocation, ventura:        "87a41137441d109ec334949c400c82b338016ab8c2d25766e9614afe8b1d3bee"
    sha256 cellar: :any_skip_relocation, monterey:       "5b90479b081bfb2a55ebdd6f8f5ebb2d5bf834fcf2a72482d7fb6310c419e53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a860d5fde8f60bf6435f68c9283422d445269c509c9c3607fe9c1b2fbbbd7a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
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
