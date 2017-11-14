require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.2/mighttpd2-3.4.2.tar.gz"
  sha256 "7330e73d5b07d5dded9e18d04681f6c34e46df6b4635ff483c57c90c344bb128"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3fc07179ad757784e676bbbfb961aedb0fcb9496bdcedcb5c5a172db4f4a7d2e" => :high_sierra
    sha256 "41f5402d13c13fc36d2b897d3b485542d1d18029dabae496f96615787fda0646" => :sierra
    sha256 "0f73e65f13d9a91427c64b08fcd56d071a7740f0da40aca8cccbc865f96b0da3" => :el_capitan
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
