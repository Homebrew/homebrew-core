class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.34.0/dhall-1.34.0.tar.gz"
  sha256 "0dbc61611d465f744aec13fd3114a9d75bbaa434f1aaa3de7e49c385d9fe1b67"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4fe8913cd2e0274a2e64cabfd86cf3566aea96a8da7b464183defc31fa4a68ef" => :catalina
    sha256 "bf824346343183b124f99640d4f59d2344d77801e62857c846a03010e09c9eed" => :mojave
    sha256 "ac41e39b2357eb6067aabe05f0bebd84058d4b04ff99dc6b598b3c586eb9496f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
