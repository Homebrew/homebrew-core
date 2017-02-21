require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.0/dhall-json-1.0.0.tar.gz"
  sha256 "514e14a765b0fd360dad7aec62980ca02424d6670be9bf5b9a5a171835a7758d"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
