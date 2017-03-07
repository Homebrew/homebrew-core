require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.1/hledger-1.1.tar.gz"
  sha256 "b254b2a3918e047ca031f6dfafc42dd5fcb4b859157fae2d019dcd95262408e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "55d095464f12b72516e799b2851f7f0a4d3fc0f9b1cf4c737f83dfafed625da7" => :sierra
    sha256 "2e70dae4bfd44dd27e48b86138090416e500169d2987df6c15750516a109001a" => :el_capitan
    sha256 "ad2d1d8a8d0f184bf436317a25cfbe8412d19bfd7ed6dc2d99a36d3b4c066189" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
