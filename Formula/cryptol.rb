require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.6.0/cryptol-2.6.0.tar.gz"
  sha256 "5f8abbfa2765ac0f6bb887edbec7032677d107c39581a4c78614e97382738f42"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "04ed08859f18cb0fdbc5c37b2db15f474ad241b908a06aeb0d890145d84fdf8b" => :high_sierra
    sha256 "caad7d780203e43fd57a8cb0eb0d30e59bc7dea5bc258dfdf938b84e26a9e207" => :sierra
    sha256 "6679c45e92d3093e89b54bcddeb1e107445afb47243a766b197240362c281d1a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  def install
    install_cabal_package :using => ["alex", "happy"]
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
