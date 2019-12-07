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
    sha256 "44f2fd4edb57e9445f5b760376de6b42f6d4c6b9b40baddb755e1afbc6f1e80a" => :catalina
    sha256 "5c1391980cfa180301c8d1979bab120326e7a27f3e3e8bea094eb88f4dd74e31" => :mojave
    sha256 "0eb531fc4cb6ab29034d4d1903d90bd1f6c5c6f3955e6389af6ff6142bc4df03" => :high_sierra
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
