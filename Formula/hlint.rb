class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.5/hlint-3.5.tar.gz"
  sha256 "98bd120a10a086c17d6bf1176a510dc12b36581e5a901f1e024555bb3ccead4f"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b773576b8d8b90b695c56cc790b4d5d0277e3c386ece4e80e6a6d928e5ce8343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "491c77ec84e7d95128d51911cdc4eeeb83c5c9432b1d0e179949d50eca98a9be"
    sha256 cellar: :any_skip_relocation, monterey:       "95ba606ac0274c30cb0a939dcf3328638bdcef24052bf936064712235aec958a"
    sha256 cellar: :any_skip_relocation, big_sur:        "56f4f58d3df7dbc7d9811a953bfa2deb202ff0322b2ed6c7e962483b6f68591d"
    sha256 cellar: :any_skip_relocation, catalina:       "7aa24d8e75820b8510767112270b96774bff7a022efd228730ca56267197cbd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998213512ceb03b544463e840d55e067299218ed517ac1f7c898b669bb2969e2"
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
