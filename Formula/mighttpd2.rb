require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.1/mighttpd2-3.4.1.tar.gz"
  sha256 "0f24c72662be4a0e3d75956fff53899216e29ac7eb29dae771c7e4eb77bdd8d5"

  bottle do
    sha256 "7f26272fd123a12d54b5cdbf52ede0131885da7e1f9778eb36b6481c6b9e4186" => :sierra
    sha256 "98d87017e4b7dc074f4da31fab05816338d01421de0e22ad037371f1dc060efd" => :el_capitan
    sha256 "b21f19f4262c05883e11b37388ff46126c1130bf84c568105e9e47b6266290d6" => :yosemite
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
