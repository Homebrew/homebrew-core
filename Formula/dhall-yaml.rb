class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.1/dhall-yaml-1.2.1.tar.gz"
  sha256 "aa68f6dc6ba5d6f10c389bf3ca741034774a55dbd2957d30895ffcc84552e8a2"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f6d1727fecef03d77014b303e8ee091b2125b6285fb13397630030f62621d8e9" => :catalina
    sha256 "7ce584be4e8595d1e869274ae6a141376f0ab4425bdb1de026491a688a4d3c94" => :mojave
    sha256 "d7c9567b16411c9b8615452643988c8d197ce0f01069cda9fc7c10b0826cecd7" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
