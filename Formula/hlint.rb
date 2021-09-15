class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.3.4/hlint-3.3.4.tar.gz"
  sha256 "189bab4a78ded3bf0db64878a0775805855aff49796396abbac5d90a81db100c"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dbfc4114cb81b399e3d998ad8ebe67d2f5d8361908159d821fd79fbeaea163f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ccdf7b77e4ed209b06b5f65007b1fc560e27d8f8d334723f92fac504d2251bb"
    sha256 cellar: :any_skip_relocation, catalina:      "2d20096003764312d23aa3c1ca4d83fc4c383e00f440c71af140573ad977bc91"
    sha256 cellar: :any_skip_relocation, mojave:        "7b3c9dbda4c9c9f37d54669cc04c91ff98ebf8f1ad90d40f23e77c81c049e4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e3e65b1785ace7deb2faaaec2e00ca3cf330cfd7200dabf92401952cd76f42"
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
