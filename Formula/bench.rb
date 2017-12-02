require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.7/bench-1.0.7.tar.gz"
  sha256 "4eb525e06c3ac6acc0a81fb3c1c4558f74bc9ce1d50806a651e9d9d2a3a6c9d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8d3039bacf0a9fa9b10188779b8c79bf7b309f79b7a98495cf04e7ef7f5f99b" => :high_sierra
    sha256 "5b668c20f1e2ec14f81aee4c84df692741f46d5b1663cebac949c769eeb04ec3" => :sierra
    sha256 "bad9f0285cc2f6307e001dc62950b35afd940f38ff1f6157bab2757aca8b9a3c" => :el_capitan
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
