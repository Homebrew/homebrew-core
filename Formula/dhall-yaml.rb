class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.4/dhall-yaml-1.2.4.tar.gz"
  sha256 "4f556e8b47a953af37a9c6985ac525d4b81e11d83ebd72a79903f552a36ea176"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ceb9184cf134bcdce5b6d8066b4957137f8da548f16ffbee3ad3e14a585061d9" => :big_sur
    sha256 "284714f8d2dbeead9fcc8482bc1f8326b24695447b5fdb0f329c859902686ae4" => :catalina
    sha256 "7318fd27cd0d055b5cc2d2bfcfaeb29cbb18ee7047f089597899aa73843c7ac0" => :mojave
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
