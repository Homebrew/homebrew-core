require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.8/dhall-json-1.0.8.tar.gz"
  sha256 "41a19771198106b08b3b0d10085f9fc2914324df94c2e7e914a61a75ba5e9c45"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "467c9466175b01656531cdc0e514e76290abdff30585fe530f7ea22610911c8d" => :high_sierra
    sha256 "bfacbfc59d1e92a87794f41a5a5046697f0603437397bb3b63e33bff408d5653" => :sierra
    sha256 "489db729476d7cfe1ab9f4a1dd81bacab5b2bb4d8144b68f53b7c8dd385d096f" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
