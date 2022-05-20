class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.10/dhall-yaml-1.2.10.tar.gz"
  sha256 "d6228d330ca593c98a1882f4d0f201917dff395b09b7bfd23e78d1940e416fa8"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1e63651f3a4dab123ae1f86583eb78c54d20f02f11a2edb81a2c1473d63fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f365fec1ec81666fa80d65301ae91f059e98911ecc1013194bb0345d8cdbe642"
    sha256 cellar: :any_skip_relocation, monterey:       "259387c4c0b3aa6899e30944bad7505e284e1da5b797372d9a5aaf5f410a691b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad37e985cdcd2b1b1e6234d3de0dab2698a08e3fc834b378e9f0abb60544dd78"
    sha256 cellar: :any_skip_relocation, catalina:       "bb98644bfa4a52e96d46331b2918399efefcc0a743f541be12836b27aff58895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e58f86bcdff44823b02d16259cc49adfa7da6e5b41b3fc4b54879d3e5e47f324"
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
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
