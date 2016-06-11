require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.3.1/mighttpd2-3.3.1.tar.gz"
  sha256 "24d177cd77b9005901ab6c8aee0f3f0c4e286a9247561665b1d0b2fa8f0e84e5"

  bottle do
    sha256 "045ffeb3a85275c0afb751c34504c9687a929520237993357263fcfd0869d90b" => :el_capitan
    sha256 "05fdcbba72139209e59bcbdc7363ce7200ba28abf18628364046b506c698f1b6" => :yosemite
    sha256 "49d5a24994f766deb84d6573d2c6835069b9bbf2bc111962c695d7d19078d85b" => :mavericks
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
