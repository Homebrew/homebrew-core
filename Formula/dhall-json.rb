require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.2/dhall-json-1.0.2.tar.gz"
  sha256 "a16ebf9524884d0ecfa2963a6c4f15a380d0fa679b0bf0f342345535a18e22ea"
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
