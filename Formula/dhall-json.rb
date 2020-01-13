require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.1/dhall-json-1.6.1.tar.gz"
  sha256 "3ce9b0a9d3a946beb021bb42589426ceb4c44cf5f104e5bdf120659ccb5109c9"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cc81f1c9f6a97d9ac4a5539b9c8c0c71c318c247253b34dba98eaf7031bd93f" => :catalina
    sha256 "76daf58beb302c6dfb451015dacbfddea53e44807e0708acce70f89a17d65771" => :mojave
    sha256 "ec70a72b710b3351d999943fc6dc3d2e0727dee5d22cc4002cbe2714dbe110a5" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
