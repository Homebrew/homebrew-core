require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.2/hledger-1.2.tar.gz"
  sha256 "06f4bae5a49916e0291b1b6d6c2017794c98f14bb22ffa20c49e9650278247a2"

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
