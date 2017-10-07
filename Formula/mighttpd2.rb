require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.1/mighttpd2-3.4.1.tar.gz"
  sha256 "0f24c72662be4a0e3d75956fff53899216e29ac7eb29dae771c7e4eb77bdd8d5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3fc07179ad757784e676bbbfb961aedb0fcb9496bdcedcb5c5a172db4f4a7d2e" => :high_sierra
    sha256 "41f5402d13c13fc36d2b897d3b485542d1d18029dabae496f96615787fda0646" => :sierra
    sha256 "0f73e65f13d9a91427c64b08fcd56d071a7740f0da40aca8cccbc865f96b0da3" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  # Fix "src/Mighty.hs:3:8: error:File name does not match module name"
  # Upstream PR from 7 Oct 2017 "mighttpd2.cabal: remove non-existent module"
  patch do
    url "https://github.com/kazu-yamamoto/mighttpd2/pull/16.patch?full_index=1"
    sha256 "372b653d14218016abfee11c170e1e4dd3641a984f8296a802b84c9543629f36"
  end

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
