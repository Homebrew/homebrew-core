require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.0.2/hlint-3.0.2.tar.gz"
  sha256 "e6ddbca24cc75774c3c5ce9ee365ed701e37a3767f773fa797cd1f50cd454d1d"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "59ce427da5649bf82b9df2bc3144bc10542bdf4106cebf9f98b270a89f04f531" => :catalina
    sha256 "b8b5af1c68a4f9685342995ba9d07bce5eca09892de1f0eb70688417d04f9f6e" => :mojave
    sha256 "0a525ee1aced0ceb5b34517b7cf76d630fe6220c38970d4058c2e828e0fdedb6" => :high_sierra
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
