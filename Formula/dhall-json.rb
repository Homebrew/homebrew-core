require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.7/dhall-json-1.0.7.tar.gz"
  sha256 "2be0d576a5148206823574457b3174c42d2c2673cc5a08e0f642f7ed5e92fff1"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e08d4cf08b3334faadb1289baa04aac66592c1c55c5d8d6e4e4e5f7426dbd026" => :high_sierra
    sha256 "12dc93f3bce956128fa26d4b957687f154e30aab581fccd79b65e54dfd0dbd31" => :sierra
    sha256 "52e09aaabbc1aae2489f5a177bce0b4bc264ee5280b1534de49a441cf1cb9207" => :el_capitan
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
