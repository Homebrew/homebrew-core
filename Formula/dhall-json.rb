require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.3/dhall-json-1.0.3.tar.gz"
  sha256 "bee92f6c0ae8eee3a8556d5f519aa57263bcc1350636d6d359e5dfb9d91e6be0"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee0cf9811887e0cf22c481902e5356aaf934ea1dd5690fad0c6293e62c9eee86" => :sierra
    sha256 "871e523ab5be7d9acd3da6a97e91a0647b665dcad6756b45287ff1d3da625ed4" => :el_capitan
    sha256 "fc58615a08cf6daf153847a1f6e62543b685e259b13b1b4c18b1446ba584118e" => :yosemite
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
