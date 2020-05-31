require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1.4/hlint-3.1.4.tar.gz"
  sha256 "bbe132ae5e2a7428e6c5a53bbb224809163996d024bb260aebc66d6637b050f3"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "b44851d8ed35fb044158bd9f0928d158fea71c4b09ba7d249ea19b24c0234258" => :catalina
    sha256 "77bbdd6bd5def7666dc837e73f3cacc25042b844fa37558d369189f4ecdcc95b" => :mojave
    sha256 "3b4b15e2a41deae9e62ed5b4a745a745bc88df8f7c377abf2aadc0197ba492b6" => :high_sierra
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
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~EOS
      main = do foo x; return 3; bar z
    EOS
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
