require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.28/dhall-bash-1.0.28.tar.gz"
  sha256 "f20fc4bdd181f2ead61e5b92b4fc4c155e21d516bc21c0f7196c59ae5327782f"
  revision 1
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "118d9869ebf9a6cfd5fcff42be4b25d3cf057e38613b4d46125d01ab8db14908" => :catalina
    sha256 "8a6441384b93ce4461c8639a3b9bea6b7e42ccdc3bfb957fc69276a1f4417337" => :mojave
    sha256 "5647557238ffdaa23c0ee08acf946df864edda4d6f123f076523732af1a7982a" => :high_sierra
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
