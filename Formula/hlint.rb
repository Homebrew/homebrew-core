require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.10/hlint-2.2.10.tar.gz"
  sha256 "041e0a025b56a5cbaf875e2a81dadfb432d1311b1cbcaf18f8fd7f321e40cafe"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "60cb3ab4c62c14446a478f5d573f43ce5d15760e0065e2f63fe9026948c9af54" => :catalina
    sha256 "3e03d100b51ce07154bd183d25a5ef90f3f7b76ebf77a52558410a172af2f2d2" => :mojave
    sha256 "8d41ad876fd22df365c58d3286d8197360bcc8731bb65b96a1bd2e7bf741ca2c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
