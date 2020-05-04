require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.0.4/hlint-3.0.4.tar.gz"
  sha256 "56f809c55592004cebb0c47043485bfdea83a4ff821e4f1aed953a5047f2e848"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "1a1c76cae91a3899b216f734895e3cec07be0b733662f94a9a0f4bdfa31c112a" => :catalina
    sha256 "86389812a5ea73471e7c5897073ec9800a60fdb615282292ee2eee2b047fac8a" => :mojave
    sha256 "98d4a5aeb962d0872a69738cb20c17986703e153b2ab261119ba164ce2210132" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
