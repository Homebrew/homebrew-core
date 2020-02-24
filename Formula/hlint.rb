require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.11/hlint-2.2.11.tar.gz"
  sha256 "7c15ec4f3d328fbeb38faf9a49c158d25ec94d82630629d4db3086da73decaf7"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "666c4aef6544a0b80c15a46126030ba79c7cbe82b7ff5b21987e8d003a6914ab" => :catalina
    sha256 "aeabf4b23ea496d58e9ae0090a1015ae86935922a5e5c3ecd4816686a3aef156" => :mojave
    sha256 "6da53ab55bb1df5a6829c59d25a0ec8fa2c7bd296c5335ef43d8848317979dd9" => :high_sierra
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
