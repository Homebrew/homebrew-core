require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.6/hlint-2.1.6.tar.gz"
  sha256 "7b08ebe2ccc6b7f1957e7eb19dfc5b58f99087275a894dc0e8cd43fcd35aadeb"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "ff9b646d4ce979cbe13556614f8b41a93086c6a392bf49d9e5110c0fa90df6bd" => :high_sierra
    sha256 "c4790a5371f6c0d27e401981bd587bb9648a6ca0cf825623c2727cad9862d9e0" => :sierra
    sha256 "3189b39e20a2dcb12176bbe554a58418effdba0cc9f25ee007f6efeb5e6b8fc4" => :el_capitan
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
