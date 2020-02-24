require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.28/dhall-bash-1.0.28.tar.gz"
  sha256 "f20fc4bdd181f2ead61e5b92b4fc4c155e21d516bc21c0f7196c59ae5327782f"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1416acab7e130daddf5fee412e74c146477d9b721f280b380d809176d7591f7e" => :catalina
    sha256 "785bd86f1d6aac31852827b08263d7d4148272b4b4f0fae6f7c314cefddb7edc" => :mojave
    sha256 "22ce8a22b5706585d65dca81dda7aa1ece47144193c1067d34258db4142b23cf" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
