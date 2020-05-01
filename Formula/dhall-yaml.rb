require "language/haskell"

class DhallYaml < Formula
  include Language::Haskell::Cabal

  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.0.3/dhall-yaml-1.0.3.tar.gz"
  sha256 "b6314d2e189d72dc56ad277c1bdef0fcfd12515b163635852befbf85b9b8ddd2"
  revision 1
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0534ab2f6a7e17e5a4732dcd9eabac91a1577b77010a7b315e5df41d8e3c897f" => :catalina
    sha256 "618b153a960992e14d6f651fe34bef63f3485739099afe5568807fc0ea323250" => :mojave
    sha256 "dd0ec693dfb315756d0ef8ec2e1b69a97584af04771440e23da7359f98498df3" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "x: 1\ny: 2", pipe_output("#{bin}/dhall-to-yaml-ng", "{ x = 1, y = 2 }", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
