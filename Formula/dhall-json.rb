require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.0/dhall-json-1.6.0.tar.gz"
  sha256 "058601eed1ffca03a71f03c2e3abd0f83a90ef06c2e0810dc3ddd225eee163b9"
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
