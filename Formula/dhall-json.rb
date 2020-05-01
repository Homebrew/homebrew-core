require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.3/dhall-json-1.6.3.tar.gz"
  sha256 "6b41f69f1c97515061b02fdbb82f867076d7ad1c345c1d1a6249348b6ca6a6b6"
  revision 1
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b352e16b1922c3862ed9ba90c457e045dfdfad4457aa2faadacedb0b93f9e9f" => :catalina
    sha256 "dadd74a6807a25b0aecb859b6d19e90de6962dd88e3b722e2fcb471d493b0df9" => :mojave
    sha256 "c2298d41f9cc418bb7033fa49c141badb380c91b956f85c0674ca8339dd24b59" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
