require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.5/hlint-2.1.5.tar.gz"
  sha256 "41f21566627d02f69f5715d883ebffd54e64e8f2af1d2376830b6880565a7102"
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
