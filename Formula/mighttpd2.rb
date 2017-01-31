require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.3.4/mighttpd2-3.3.4.tar.gz"
  sha256 "9a8dd3e2bf2a62f34695a8baf8b715223c3aa57de1c3b30d5a604d364ae1d4b4"

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
