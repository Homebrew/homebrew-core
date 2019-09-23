require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.23/dhall-bash-1.0.23.tar.gz"
  sha256 "9d9c55894e1fb96fa73a53ed79815fd6eaa919174fa2aa60e362cfeae35fa859"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10e0c5b9f7bbd53f281b670eedfaac470cd1d761ba0f3cb67e06c72d1a41304a" => :mojave
    sha256 "c921347c713b1e6f20158e63c0d7dd725af5c53815b3c97874a4d4be56dd40d3" => :high_sierra
    sha256 "65614d05f2e68421a5ca744042731828a2035961e6ad8866b9671667ee530f7c" => :sierra
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
