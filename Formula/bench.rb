require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.12/bench-1.0.12.tar.gz"
  sha256 "a6376f4741588201ab6e5195efb1e9921bc0a899f77a5d9ac84a5db32f3ec9eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd770017ec21cd829d97013812172c21dc6ce8b00426029a692f5dd5d82dc0fe" => :mojave
    sha256 "c6cfcfc380c022f98a32a061268dca710f109600aa6d52c5b5e541855889ea14" => :high_sierra
    sha256 "54eb5c88dc8c8d8fa43a16fa5439b2592f0fac57bf1eeb895b181de6b2d56f94" => :sierra
    sha256 "7081e2d83fb8dee4d72fa203e0d6751eb70e1d38d64c5366f1f04cdd72fec90b" => :el_capitan
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
