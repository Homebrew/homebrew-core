require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.4/dhall-json-1.0.4.tar.gz"
  sha256 "60d08cc7b89d60866a998e9fe9c3d8aa829b2e1530a6b290916f529aa40e994f"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da08bedaadbde8e926d88a63f8f060170e138d620c20cacb4bbd1fdd6f7b54ec" => :sierra
    sha256 "deb84c48ef598d4d7d95a2d51051ab50eb0821d0f969f6301795d7d09f2fc972" => :el_capitan
    sha256 "b56b05a088808e65a5aa17be13675504ca49a50ae4cd395a28a0709912f40e63" => :yosemite
  end

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
