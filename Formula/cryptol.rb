require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.5.0/cryptol-2.5.0.tar.gz"
  sha256 "910928617beb1434ad5681672b78ede5dda7715b85dcb8246fa8d9ddb2261cf1"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    rebuild 1
    sha256 "f8d570b0356554ecedca6d9e98424a32d6e3d7c3bd2bc0404dafeab024f38164" => :sierra
    sha256 "e08c9574f9a81cc94f09ba5266c83e5fc5923e689ad67f72b24fddcfeb3448b6" => :el_capitan
    sha256 "5f2851f14e27b4cb9989f28f23bd019b889e17cceec264a258a33983bbbe5a47" => :yosemite
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
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
