require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.3/dhall-json-1.6.3.tar.gz"
  sha256 "6b41f69f1c97515061b02fdbb82f867076d7ad1c345c1d1a6249348b6ca6a6b6"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "374cc21437ade63f6fef7fc7bbb7b6d9468d565ee7e4f7d3536a5b9ae90c102d" => :catalina
    sha256 "f2e57d82a735f36881a6b58bbf8d72e7cbe3238226087740a166b12f483887b9" => :mojave
    sha256 "b867b30ee8bfc4fd4a08dee906388483acf54144d3364763f1d63ec20260adcf" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
