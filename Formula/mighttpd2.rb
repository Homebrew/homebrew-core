require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.3.3/mighttpd2-3.3.3.tar.gz"
  sha256 "f716ab686c9edb2d549f03b069c3b630dd5c147eff6ab1317781450c47a8f7b4"

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
