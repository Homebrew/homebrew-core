class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.1.0/dhall-yaml-1.1.0.tar.gz"
  sha256 "72919ce641af46b6f2e8884ad358f545b58023682f65b2b3d1d1499974fc9c1a"
  revision 1
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3561747fc8f2c4f674007bec5edb4b25c94e986cd8fc63f59faaad01aff723e6" => :catalina
    sha256 "a89f7bf087f4718712b48175340bda6b8c63bb7d526cff3f0fe3605d2a1ece6d" => :mojave
    sha256 "253aba683a6574aadf3823b66452cb169ed1549b8a83ae0017cde79cb712ca32" => :high_sierra
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
    assert_match "x: 1\ny: 2", pipe_output("#{bin}/dhall-to-yaml-ng", "{ x = 1, y = 2 }", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
