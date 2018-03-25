require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.13/dhall-json-1.0.13.tar.gz"
  sha256 "3a256300d29feb19181280272fd7df79aecbb82e3429084e9255bdae59fa570f"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "138a6476f6775eb0277eb70a08c0ae23c2e4dfab0ae677b015bbecc9b8283877" => :high_sierra
    sha256 "eafc22ae451b9b1b69908d846ff8ff70de803fab944c236ec8cb2624e0b18b86" => :sierra
    sha256 "d88cd50ed467d343b948e267bf3b458999ef41af0787f2ed1c20a9121fab737b" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
