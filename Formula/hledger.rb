require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.10/hledger-1.10.tar.gz"
  sha256 "f64420f852502e84dfa9374ace1d00a06ecf1641ad9fd3b22d7c2c48c1d5c4d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ae8f7b5ff4619b067064183e3939da3cbb62f4cd317803a24ef29d3ae955815" => :high_sierra
    sha256 "1ac46662414ced9e4e8949060c5060a8c9e55a9894dc362f59198ce388893184" => :sierra
    sha256 "d36fc1aa14f0a5f14dbf4a3bed694a5a9a1d507735ebc6955470c1eae64ff4a4" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
  end
end
