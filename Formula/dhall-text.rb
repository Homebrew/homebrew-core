require "language/haskell"

class DhallText < Formula
  include Language::Haskell::Cabal

  desc "Template text using Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-text"
  url "https://hackage.haskell.org/package/dhall-text-1.0.18/dhall-text-1.0.18.tar.gz"
  sha256 "4d6f9477806cfe32ee415ca5763c1c0ded7b3137215a619a2fd663fa8e919bdb"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "ABC", pipe_output("#{bin}/dhall-to-text", "\"ABC\"", 0)
    assert_match "123456", pipe_output("#{bin}/dhall-to-text", "let x = 456 in \"123${Natural/show x}\"", 0)
  end
end
