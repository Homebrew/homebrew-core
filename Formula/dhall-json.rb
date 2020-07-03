class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.4/dhall-json-1.6.4.tar.gz"
  sha256 "3f0162949d53e10c23ee11ddfe92a808dc5b18c5a40289015c65baec0450266f"
  revision 1
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30e4dd29ec472fb53ba842fe792e0ed75d82530750621aeddd9ec9e642f12351" => :catalina
    sha256 "cf806eab9566d74071a545e27dd26a568cbf019d87705f059d98c100fb21c9bc" => :mojave
    sha256 "953853ab55f1421a6fed8908407593c62b60d20d28a1a3daac47d04f2d366efc" => :high_sierra
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
