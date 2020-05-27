require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1.1/hlint-3.1.1.tar.gz"
  sha256 "7b5f8626eb9349eb9e9a7d773ab19ca6f77bfcfd7610d2ae0e15e80f653f6ce0"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "91511a4ac9487c937e0fd32ee5c0a57037c9a247c82f02f4c7c1f059af1df513" => :catalina
    sha256 "396493aa99fdf6da60fba21c068e4fb1d3664f0cda8cf695161ada8d6b22ae38" => :mojave
    sha256 "348918091d040bd38e829ed00c0b9be2fa58257e5554704c7c2bf7979a095f5b" => :high_sierra
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
