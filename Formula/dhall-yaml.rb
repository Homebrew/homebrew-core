require "language/haskell"

class DhallYaml < Formula
  include Language::Haskell::Cabal

  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.1.0/dhall-yaml-1.1.0.tar.gz"
  sha256 "72919ce641af46b6f2e8884ad358f545b58023682f65b2b3d1d1499974fc9c1a"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "911319d2b7f11dc04f6b6133c1cd74f8389539e14da8f7877107a929727f7d15" => :catalina
    sha256 "343b103787744028a6fc4501becba24ce71053e43e1a2ee5cc43bc036a16ee31" => :mojave
    sha256 "5388c7eedabb5294d21fccee32d989d622ce2b36bdd4904c4b7469c0554e2fdb" => :high_sierra
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
