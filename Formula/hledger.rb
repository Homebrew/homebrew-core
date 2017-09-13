require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.3.1/hledger-1.3.1.tar.gz"
  sha256 "ad631c0fee2c554d40b5571544f140b6255bcd0866324be909aebcce6c935440"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbc9f615c11543380667979883b5b93fc335b1891616a7b6f7569f0f18e1d394" => :sierra
    sha256 "95ec2ed7af8637bd2309d9fdfc651ec45ffd6ba13c76bb37c20a2ded98ae7c12" => :el_capitan
    sha256 "98432ae6db2c7320ccf87d471a3ef0263407669e9129f4c6433b1fd8d70e3d35" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
