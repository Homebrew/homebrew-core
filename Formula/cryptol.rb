require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.7.0/cryptol-2.7.0.tar.gz"
  sha256 "46c6ba5d63c0cdf074e57ea07b09dc84751a6608a9a66e552ebe2b7a343ed393"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1184304ff56086e3701cf243ed3daadf11aa92adf257b294bdf2ea0d1d7fb65" => :mojave
    sha256 "2c248ddca38fc90b2ff5f7c8c671f298216d1a5e6bc699b77ccc99aebdb7b5a5" => :high_sierra
    sha256 "2c9e9921e770cb5837fa0d25408e3120a2d5929d98ca2a8163eeba04db4001fe" => :sierra
    sha256 "11dc3aa5ee61b11449f98cd3450237b92727abbf384580d339c564cd6fdefa6d" => :el_capitan
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
