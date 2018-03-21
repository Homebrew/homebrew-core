require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.12/dhall-json-1.0.12.tar.gz"
  sha256 "4b493f17914f659ce42f656104b9ffbd7847f8d19455c447c8af33779cd39a9c"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2691fefc86289644cb92704cbbbffba8cbd67566b5797ab9554f869c15cf2460" => :high_sierra
    sha256 "8f8001b1da262e3416c5b9481b39c9c3f2daefd4a61c208318799862e8301619" => :sierra
    sha256 "c04749897de1a0a68d535e28c6692df5bfaa76b76893c819dcddeefa42e5767a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
