class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.1.0/dhall-yaml-1.1.0.tar.gz"
  sha256 "72919ce641af46b6f2e8884ad358f545b58023682f65b2b3d1d1499974fc9c1a"
  head "https://github.com/dhall-lang/dhall-haskell.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2a41d5aeb4bae4e2640167e0009d65157a53d13abe8d31018e3fb28ccd953285" => :catalina
    sha256 "311637c77e96893b0a6f13bc1ac9f90de628c64edbd1f810d229b8c4358bbde7" => :mojave
    sha256 "e123fdeb751562e413e682bc412f04928c7f097bf928af848e29b9e38a1651e1" => :high_sierra
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
