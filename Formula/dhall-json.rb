class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.1/dhall-json-1.7.1.tar.gz"
  sha256 "eefdce642c5ada8c3c7c08dc389fcdc52f88f9e6c50c8b7bc84404d5e14e0c95"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a83bdc7433f7c86f3bfd84b8b6bc92b41a902306bbc73972dbb8a8245d69f54" => :catalina
    sha256 "60171764b0f006df86d88b2b0db0e86633e55d002b68353273d2c42a76863beb" => :mojave
    sha256 "7e69b892113937496bf6a3738261d8473b1e9c29c08ffb52c3acd1673d0f97d9" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
