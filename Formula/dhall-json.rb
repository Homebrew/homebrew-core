require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.7/dhall-json-1.0.7.tar.gz"
  sha256 "2be0d576a5148206823574457b3174c42d2c2673cc5a08e0f642f7ed5e92fff1"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "246ebfce84d0a72db29f8c9be7faa7f3ccc3762affea1a3d5d9800e3922f26a6" => :high_sierra
    sha256 "f4a963e1953a61fde793cf0e5b3f6f73908d04791954afd0a7d86ebd857f830e" => :sierra
    sha256 "eddcc81830adc1e0a602f6ea1d8db8b8d1d3e2709140e53101ac70aa592df32a" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
