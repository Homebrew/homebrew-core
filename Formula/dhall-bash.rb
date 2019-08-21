require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.21/dhall-bash-1.0.21.tar.gz"
  sha256 "2801d68cba9682a493b7ff54e3773aa262c59db7e37174fcd7a6faa033073b1b"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4d548e7aed6ed60d1a3ae5c0813ec8bfc9504a28b9bc5b4778136fb9804e2ae" => :mojave
    sha256 "6b29a05b3846fe870658c1bef2d52af49deff1d91f8bb5bfb311ebf9a6ccd7ac" => :high_sierra
    sha256 "eb836ac98acf3dd6b0efd428c7d1006627cc4139f9245b0643f71ff2cff11795" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
