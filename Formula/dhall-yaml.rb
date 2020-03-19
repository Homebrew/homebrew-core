require "language/haskell"

class DhallYaml < Formula
  include Language::Haskell::Cabal

  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.0.1/dhall-yaml-1.0.1.tar.gz"
  sha256 "4ed4351c1850363607ed025a035f973db5c375b4650da692f69652837935a3de"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d7d9ac00313fb6ce4c24ee1eca28cf9d30d3e1c4f67010fb78385665105055e" => :catalina
    sha256 "f96cc310eb0e8b387def35b3b3736d8c0062ae51ad306f7bf68acaea6849724b" => :mojave
    sha256 "0f22a381aa9e6093aeac60aa5dc70c692dabc1c91014501fe9294deea410d423" => :high_sierra
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
