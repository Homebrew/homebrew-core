require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.2/hlint-2.2.2.tar.gz"
  sha256 "d717f06091d4b651671ffa3c3d88115d353a595b7853f9860af3b74d3eeb20ec"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "9d89e171fa49bcc66215b8e0515b132fdd0676fb5fb07ffc5c05c3e78b29c528" => :mojave
    sha256 "3491e13e543374fd8773217596afefaee09e2ea0f7655b8df9bf97f52c5b4cf6" => :high_sierra
    sha256 "7fab1b5f4518daf94a7ff58294de43956da83ed079da3f1aa80508a494fcf99a" => :sierra
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
