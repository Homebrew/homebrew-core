require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.24/dhall-bash-1.0.24.tar.gz"
  sha256 "2f7d025f98ba3b06d5e3b23198541eee76dd305d4115cedb8799662c86408c52"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87f050684d32d9fb8ae66ff0d5107af841afc086e73adeb084d016cfbf8033fe" => :catalina
    sha256 "ce348f4902e29064800ae838e3685bf18fb3f4575f046c7a6398e3b7e493f748" => :mojave
    sha256 "5c99eb69cf75b888f2a1414b0caf4ec567f72883e3606ad5a32c7d5d253603bd" => :high_sierra
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
