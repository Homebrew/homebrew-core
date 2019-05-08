require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.17/hlint-2.1.17.tar.gz"
  sha256 "431a6de94f4636253ffc1def7a588fec0d30c5c7cf468f204ec178e9c6b2312f"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "caf49a8b1ef732affcd024be46b1759232c85bdd552a1740e751b0aa28b4f21f" => :mojave
    sha256 "ce751a897045abeb8bf35dbb90ca0f3133a681c62e17ba81ba72ef53fa0ee7d9" => :high_sierra
    sha256 "5aa6962f99a01d1578fd2d20f9709653c7db2bfa31835e819cd3c3388751300a" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => "happy"
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
