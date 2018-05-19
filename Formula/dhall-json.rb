require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.0/dhall-json-1.2.0.tar.gz"
  sha256 "bfb5dc1b423d5f4d637d1c7ee04a5ce34ecc9aceb9fda5b00cb246ed1ff3484f"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcfbce52a79175254dc6fb3846aaca822e2c7023546f806a897ad67308488291" => :high_sierra
    sha256 "ffc6e7a92a58d7658eb5b7f316cb93db0b66142b634b31946b083f4dccf11100" => :sierra
    sha256 "4d7cc8f1aba216afe12140dd27ce221e5e6458868cb8597b7b32b87c207cae44" => :el_capitan
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
