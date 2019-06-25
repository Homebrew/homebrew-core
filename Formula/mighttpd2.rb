require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.6/mighttpd2-3.4.6.tar.gz"
  sha256 "fe14264ea0e45281591c86030cad2b349480f16540ad1d9e3a29657ddf62e471"

  bottle do
    cellar :any_skip_relocation
    sha256 "feb0e395dd90bbf9650f9a551a70f6953e1fcc16016a61ee38d212717d19c202" => :mojave
    sha256 "418c720124aaa01f2f2552d314041acf13f97b5afa53e4320660a5710430c6f8" => :high_sierra
    sha256 "6afe11e98e8245d8a2b1e199b3052829898e37a3fb01614eedcdedfd10533dfa" => :sierra
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
