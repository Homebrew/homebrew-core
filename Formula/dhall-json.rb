require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.9/dhall-json-1.0.9.tar.gz"
  sha256 "86a67f9eb51dc03b1ab97e7708a5bd540e4fb895e1c65603728ca98ab6deaf77"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a943353fff439561ad8cc87a562c15c27dfaa3391cfa573a5457c721210e1c7" => :high_sierra
    sha256 "ae9a8ebcda47c30cdb27c836ddc900791372d919dd43abf37f6ccb7112e9f9df" => :sierra
    sha256 "7511d14958f8ba0f6211593e8d82aa4e1e830d8d7619c63f1cb0b8fc6851d58e" => :el_capitan
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
