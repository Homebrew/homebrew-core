require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.5/mighttpd2-3.4.5.tar.gz"
  sha256 "e43b377e3779c8d7bf9c2d76e26da190ab01061c591ce56f6e540689d35748a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "121f2b0b496d2ebed1eb141e225e6c708c110463334e88d3f0ae03f8e1f0864e" => :mojave
    sha256 "ffb3a6449fa17c79ebbeec0e27f94506d00ef840eb3549e09c96730bcd91abb1" => :high_sierra
    sha256 "24d9423146d9c85960de6db87eace6081b3d3385b9f0c9110afe63d2e9e34a7e" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
