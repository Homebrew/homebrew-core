require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.1/dhall-json-1.2.1.tar.gz"
  sha256 "999cd25e03d9c859a7df53b535ca59a1a2cdc1b728162c87d23f3b08fc45c87d"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25736b0e9d678c5a3dc6c477f15527cfe9761bf85398fc3bf6e9cbe13e391b58" => :high_sierra
    sha256 "d935eb5cf5a22930e6bdc5f7bd4b3fc5ba391bd243d83018c46307c23b550a03" => :sierra
    sha256 "661985f1086344de54a417d327dece699ec97dc21dc814bd3f926ccc2e9d12ef" => :el_capitan
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
