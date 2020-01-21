require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.8/hlint-2.2.8.tar.gz"
  sha256 "3f96a64da6c4572a7dc939c8f9b96d2a95cda27616f76f1de89d02f9d59d1c21"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "7aca75b0eb86d0bf1d25a5afd8503579767cecf71be419aa5b2fa1b20ccea601" => :catalina
    sha256 "3c8692748688c123a27b69a7f18a23ec3971ed7ca04d349699d569d20c2c8078" => :mojave
    sha256 "e324f3199e969dc9c3583fe853520785c65b52b4efa063b6ff723dd98fbc1304" => :high_sierra
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
