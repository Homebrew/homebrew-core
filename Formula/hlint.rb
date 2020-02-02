require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.10/hlint-2.2.10.tar.gz"
  sha256 "041e0a025b56a5cbaf875e2a81dadfb432d1311b1cbcaf18f8fd7f321e40cafe"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "99a807f440b24c4a95776161f969549ecdf28580098f6e5884fcc22edbf0291c" => :catalina
    sha256 "18ede9017545ba3b93a35d1ed3b0789212def88645b2b7a074e28bc2cace5085" => :mojave
    sha256 "9215dbd210eb213e93d0fc1d62e0df578fc89ba51c20566bb889f05459103249" => :high_sierra
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
