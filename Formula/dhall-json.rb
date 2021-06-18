class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.7/dhall-json-1.7.7.tar.gz"
  sha256 "94d2ef7ec16a36a5f707e839e883a19c5cc9b921083c2c5f6245119019006698"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9a107d67c50e6ce85b9f8764f952bfae8fae445a632a89ba7e661f5371007ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "651c2889bce3cd07dbd893c44ef8039b625eb2954d72d54e466f59bbc896a2e8"
    sha256 cellar: :any_skip_relocation, catalina:      "264c20e5927ecfca56518c9954b71a466b1ef1843fb290902837533484021c85"
    sha256 cellar: :any_skip_relocation, mojave:        "224146b1c09892063a492f8fcbdc2f312abf439587da413414377d85b6e419aa"
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
