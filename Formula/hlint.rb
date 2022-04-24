class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.4/hlint-3.4.tar.gz"
  sha256 "76fc615d6949fb9478e586c9ddd5510578ddaa32261d94f1a1f3670f20db8e95"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a5f92b276bbc06b17e1c8a412060d4796c2cead40462b9f1b048b253566e066"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "456280c4ea41c06459ce36aeacf70b8e573e669e1d540282faca278408a32636"
    sha256 cellar: :any_skip_relocation, monterey:       "697145d67e8aad7d29051105359bced5ad8bafaccefb23ed0fffc51cfc745c56"
    sha256 cellar: :any_skip_relocation, big_sur:        "30b808accedb87013ff9c79b9445a2be53ae506545199a27ae51a91cbdb36dff"
    sha256 cellar: :any_skip_relocation, catalina:       "d1099973d717dc7aa58a0c1d75267db2aa7d84a9868949adf783b04ad32ff4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eed0fdf757d1265239b58a0b34a28803e3d53b1cae8f2529d14f37850993ee1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
