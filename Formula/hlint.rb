require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1/hlint-3.1.tar.gz"
  sha256 "5021a77468ea8745a5316265db08eebda7fe9b5e5f3a5500e753aad61c5b27b0"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    rebuild 1
    sha256 "0c505b487cdfa727de7b67d6cb6098d4e04a7d0902e837223b68ccdfaf3826e4" => :catalina
    sha256 "e2daa3b2d8a1dcef315c303bf72bc8a444f2dd1ca6633f65ddda28fb96a65456" => :mojave
    sha256 "4cfe06ff802e64a1fefe948748879d240b1b2f1338afa5214ccbdcf391826092" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  uses_from_macos "ncurses"

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
