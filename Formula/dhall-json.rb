class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.4/dhall-json-1.7.4.tar.gz"
  sha256 "c98e13cd6c4cda015bdbbf28b6d64c3f559b149e314577f6db315cb5f9d9f4e3"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8bbcdfe78eb0c0fead3f5ff9e037649ece167e04c72f8293cc056544089e40b7" => :big_sur
    sha256 "c532f257507c5bb20320a0ad374ee4eccc0b9f4654eb0a919da8b2c90f59784c" => :catalina
    sha256 "4ecf9c8416f990b951bdd0350747ab75cd8e3e3d860824cd35ad0b80870e0dd2" => :mojave
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
