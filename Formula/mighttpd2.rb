require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.6/mighttpd2-3.4.6.tar.gz"
  sha256 "fe14264ea0e45281591c86030cad2b349480f16540ad1d9e3a29657ddf62e471"

  bottle do
    cellar :any_skip_relocation
    sha256 "84414d7f04843f9e5a27346b57e8a32a0cbe1a1ef26c2ebd2155ef58a53723dd" => :mojave
    sha256 "16d63c6d28b2928b970e1096ed7c4b695e03eecbaff1c7f37277f790f51d10c5" => :high_sierra
    sha256 "85a39b421f5806695db43f0b7009eaaf79fb5a25c943d8d3786ad45ac6923a2f" => :sierra
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
