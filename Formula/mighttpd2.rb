require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.3.3/mighttpd2-3.3.3.tar.gz"
  sha256 "f716ab686c9edb2d549f03b069c3b630dd5c147eff6ab1317781450c47a8f7b4"

  bottle do
    sha256 "d2b5a274f84ec67fc75688a768d49ea8d9106ea44412c6848cee22431e0c0df5" => :el_capitan
    sha256 "c156702fc0ce1fc115df23f73923bb27c357aee4e5d0db424beb85947510383a" => :yosemite
    sha256 "b5082be8f6888b3fc038408f6face1f3afe6206d38c1b287aea6f9dfdb3c1994" => :mavericks
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
