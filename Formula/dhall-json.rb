class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.2/dhall-json-1.7.2.tar.gz"
  sha256 "926d8f0028a4ccd8e26e26882125825c4c9e3c1f0a6f1a187fa15a27a0bd35a1"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f2f991304d825504e92d5fd7b55416f6ec1189ab7e5a28c389cad9f0e12e1655" => :catalina
    sha256 "eea78eac300ae29de3546034c57a61ca70add32fcb27c2814bab7cc3f44bd4f1" => :mojave
    sha256 "5278e209697b20d484a47dd4fe691328a486ddabf0db531972114c2415192cfc" => :high_sierra
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
