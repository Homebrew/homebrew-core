require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.9/bench-1.0.9.tar.gz"
  sha256 "3c43d5b28abd7d07617ce5bf44756e8922db2dfbb39d7b123427b20eb8a9a830"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb92f99fc8e96533b972360b597b0f07be7991797cd682e218cc7413d7915c54" => :high_sierra
    sha256 "1d3e69f0dd375f2153cc065201dd08cc12381ef336e91eb4f9e80eb4866cc833" => :sierra
    sha256 "2654ef335eb7546fdfde72b70bf319dae6ac5c06c32514540bd0d843ac4a47e0" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
