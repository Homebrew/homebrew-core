require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.0.1/hlint-3.0.1.tar.gz"
  sha256 "82e0daa5ffa3ab8957183271b8c801b3f5a2864cb9475f32987a09606a7d27e7"
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
