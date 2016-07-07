require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.4.0/cryptol-2.4.0.tar.gz"
  sha256 "d34471f734429c25b52ca71ce63270ec3157a8413eeaf7f65dd7abe3cb27014d"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    revision 1
    sha256 "e120fc36eb8037afeb3f36e03b2af6b42a8edb396a0ae526265f4a54333bf625" => :el_capitan
    sha256 "53477d30e0dfaa39787764c90f6353ca08ff4bec92eb3f8ccfbbae8fb6d107d5" => :yosemite
    sha256 "5f7d3090604c66df255d93ddf02b2325ade12cbad907428cd01eba2e1fb47cbf" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3" => :run

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = <<-EOS.undent
      Loading module Cryptol
      Q.E.D.
      Q.E.D.
    EOS
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
