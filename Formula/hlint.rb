require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.10/hlint-2.1.10.tar.gz"
  sha256 "1cc4d90ed2b696563ce1614c2a17070be2cd808c7affa782359995f352155aa5"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "a801749db3aa79d4fe4eb2af80428d917c2c5100c99baece8d680b648e159b56" => :mojave
    sha256 "8460e3872f551304867eabc8bab6def0eab159b85a56fab7e83088ebe1a8840e" => :high_sierra
    sha256 "600c695052a301710778baf8131fb1dd1e138fd6b12ae6660610981b94c1d4dc" => :sierra
    sha256 "1d0650d58fb30e7f00a05d059e2948b17af09eea1162e17fbdb905b4d15ee752" => :el_capitan
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
