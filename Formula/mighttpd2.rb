require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.1/mighttpd2-3.4.1.tar.gz"
  sha256 "0f24c72662be4a0e3d75956fff53899216e29ac7eb29dae771c7e4eb77bdd8d5"

  bottle do
    sha256 "a6e59a654b245351c7e1c22e4bb41c9d597f9dca58c56c7866802940c0a06584" => :sierra
    sha256 "49ae8aa503d8eb1e5fedc830b0b6a0ceea817cb9cf1c74725156505f5eac9a84" => :el_capitan
    sha256 "6380d985fae9cf067c134f30f7fcadb2fb6d1807e17f54ba01a3b1941638bba0" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
