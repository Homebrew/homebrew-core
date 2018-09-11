require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.10/hlint-2.1.10.tar.gz"
  sha256 "1cc4d90ed2b696563ce1614c2a17070be2cd808c7affa782359995f352155aa5"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "46d326207501872cab48d7f88828abe89dcfd0cf7a61313a1fe4f97db49c4e84" => :mojave
    sha256 "a48d46cdd3aaee9ed2ae2d0decc4f9a4ddfe3526095917eff61c010b7a1b545f" => :high_sierra
    sha256 "ccf6f37b1d44cc063bdc08b03cceaa6589c39266e54d406096661ddc48d8a368" => :sierra
    sha256 "2610f48e027a3a47e510920b5f55f1791009ff4e164b4a021aafd9113cefb3c4" => :el_capitan
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
