require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.0.4/hlint-3.0.4.tar.gz"
  sha256 "56f809c55592004cebb0c47043485bfdea83a4ff821e4f1aed953a5047f2e848"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "555e51f0fc3741d2fbd6282ba120fa7ff755bc5d83703c85504eb1f8ff3ee170" => :catalina
    sha256 "312be3c601bb7e7e3f4104983af1c3ec58a6c653d01d6ab8c1bf167fc71cdd01" => :mojave
    sha256 "4d313e73741877fe103c0bdf1105405d40bebb76da1c1b14d83eea346488d305" => :high_sierra
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
