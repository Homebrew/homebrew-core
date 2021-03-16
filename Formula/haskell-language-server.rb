class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.0.0.tar.gz"
  sha256 "14e28d6621d029f027fae44bc4a4ef62c869dab24ff01b88a2e51e6679cbff6c"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ff41767b9a34b033c176518cefcae7c92beab42a2eb100c5ac98b9ffe27d8c5d"
    sha256 cellar: :any_skip_relocation, catalina: "85c08c2eaa6e16de56173eb17bd3a25d5e7033268ae3215b1ee370931e30998d"
    sha256 cellar: :any_skip_relocation, mojave:   "76a05d6b7ee7ef5f37a308afa8f6cb8a6c5da9f58c50e98c520e7fdae9c152df"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  def caveats
    versioned_ghc = "ghc #{Formula["ghc"].version}"

    <<~EOS
      #{name} is built for #{versioned_ghc}. You need
      to provide your own #{versioned_ghc} or install one with
        brew install ghc
    EOS
  end

  test do
    (testpath/"valid.hs").write("f :: Int -> Int\nf x = x + 1")
    (testpath/"invalid.hs").write("f :: Int -> Int")
    assert_match "Completed (1 file worked, 1 file failed)",
      shell_output("#{bin}/haskell-language-server-wrapper #{testpath}/*.hs", 1)
  end
end
