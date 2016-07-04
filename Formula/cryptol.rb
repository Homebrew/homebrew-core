require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  revision 1
  head "https://github.com/GaloisInc/cryptol.git"

  stable do
    url "https://github.com/GaloisInc/cryptol.git",
        :tag => "2.3.0",
        :revision => "eb51fab238797dfc10274fd60c68acd4bdf53820"

    # Upstream commit titled "tweak for deepseq-generics-0.2"
    # Fixes the error "Not in scope: type constructor or class NFData"
    patch do
      url "https://github.com/GaloisInc/cryptol/commit/ab43c275d4130abeeec952f491e4cffc936d3f54.patch"
      sha256 "464be670065579b4c53f2b14b41af7394c1122e8884c3af2c29358f90ee34d82"
    end
  end

  bottle do
    revision 1
    sha256 "e120fc36eb8037afeb3f36e03b2af6b42a8edb396a0ae526265f4a54333bf625" => :el_capitan
    sha256 "53477d30e0dfaa39787764c90f6353ca08ff4bec92eb3f8ccfbbae8fb6d107d5" => :yosemite
    sha256 "5f7d3090604c66df255d93ddf02b2325ade12cbad907428cd01eba2e1fb47cbf" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3"

  def install
    cabal_sandbox do
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    result = shell_output "#{bin}/cryptol -b #{(testpath/"helloworld.icry")}"
    expected = <<-EOS.undent
      Loading module Cryptol
      Q.E.D.
      Q.E.D.
    EOS
    assert_match expected, result
  end
end
