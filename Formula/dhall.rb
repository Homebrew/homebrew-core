class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.36.0/dhall-1.36.0.tar.gz"
  sha256 "9207c8becbbc1890568b861d35a623e10451feea0e0d34b317ec77966b6f8b04"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ad07e516294f9b2d8b9c60d10e1a82784609c4f218fa045ce981d889dbd63dd1" => :catalina
    sha256 "32766c9a63c4ab1a45f2b6fcfae88acb7d97971045bc89ab7c491d92f52dd2cf" => :mojave
    sha256 "d42361066cb208d5fac715c41a19253132180f85fb3030ccc3fe3813268bcf8a" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
