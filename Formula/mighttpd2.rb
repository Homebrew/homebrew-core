require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.3.1/mighttpd2-3.3.1.tar.gz"
  sha256 "24d177cd77b9005901ab6c8aee0f3f0c4e286a9247561665b1d0b2fa8f0e84e5"

  bottle do
    sha256 "cd1946c30b560973e279d21b1a59e8b5d2d09d51d32283275ce876c21f627c7e" => :el_capitan
    sha256 "e09fc4ac2f592186a0e865527dd55d7cb1baa8190d088b3ecc7f05e5be8036e2" => :yosemite
    sha256 "e550287f94677fb7c7179e2aea9441cc7d46c54ea9c4176a2641d18396a0a463" => :mavericks
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
