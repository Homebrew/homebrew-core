class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.3/dhall-json-1.7.3.tar.gz"
  sha256 "7d8e525dfbbfc7abce0356fff5e3e359e1af68a069c0e383acd667e031b1412b"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4ea653eb1cb195d00babd09e2be764192ef147fe0fbc4a3ffa2bddf34ebd35ac" => :catalina
    sha256 "2fc11a903aa8cee97d282dfd23d53735e5518614f661e1e4a682a948cfbd5a52" => :mojave
    sha256 "649a388ce623720279b22a7528751f92927054f00190e849a21150de305b2cb5" => :high_sierra
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
