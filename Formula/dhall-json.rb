require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.1.0/dhall-json-1.1.0.tar.gz"
  sha256 "87e54afd44d3796ffeec42a149697e65b985e3297297bcc26e1fc9d77eb0ca8d"
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
    # Remove explicit dhall constraint for > 1.1.0
    # Upstream issue 28 Apr 2018 https://github.com/dhall-lang/dhall-json/issues/24
    install_cabal_package "--constraint", "dhall >= 1.13.0"
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
