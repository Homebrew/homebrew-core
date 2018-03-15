require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.9/bench-1.0.9.tar.gz"
  sha256 "3c43d5b28abd7d07617ce5bf44756e8922db2dfbb39d7b123427b20eb8a9a830"

  bottle do
    cellar :any_skip_relocation
    sha256 "61c7fa791351bd4c9d7f8f0c119531e17d012551f623f868090cc93ff7661b8b" => :high_sierra
    sha256 "a55d0b947a65da702c8788e6cd81fc448862357d7565681582c8e27ce241c629" => :sierra
    sha256 "8db49b912fa0589be1e1c1d334855e5d63b620dc6573971b5003c87924d03098" => :el_capitan
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
