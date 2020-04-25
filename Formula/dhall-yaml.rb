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
    sha256 "4e7aa075a5d21a38a08d1942195888c866d0f63588a3d7b02cefa7868e6b042f" => :catalina
    sha256 "9559fb18526197b0d82025e9736a94025059a39de2d37b1a18434c24775005a4" => :mojave
    sha256 "b8d8413255a6ec06b3f5c2ca3dfcb2ae134c534e38af4d42a54a0f12d525a50f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
