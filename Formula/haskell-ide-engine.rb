class HaskellIdeEngine < Formula
  desc "The engine for haskell ide-integration. Not an IDE"
  homepage "https://github.com/haskell/haskell-ide-engine"

  url "https://github.com/haskell/haskell-ide-engine.git",
    :revision => "0.2.1.0"

  version "0.2.1.0"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "git", "submodule", "update", "--init"
    system "cabal", "new-update"
    system "cabal", "new-configure"
    system "cabal", "new-build"
    bin.install Dir["dist-newstyle/build/x86_64-osx/ghc-*/haskell-ide-engine-*/x/hie/build/hie/hie"]
  end

  def caveats; <<~EOS
    This version of hie is only compatible with projects built with the version of GHC used while building this.
    Visit https://github.com/haskell/haskell-ide-engine for instructions on installing multiple versions.
  EOS
  end

  test do
    system "#{bin}/hie", "--version"
  end
end
