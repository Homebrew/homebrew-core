class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.2.1/hlint-3.2.1.tar.gz"
  sha256 "ae5c0d3a90fcfe64a19abc655cda2027e5b21fff613088e3c4caa3218ad1229b"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea96ebff70add4db014bd83c57f71f8f9df4ed1c437942959192b94fbdaac940" => :catalina
    sha256 "6b2e4de58ca753b7b91cbcbc004186de64c84be82761ffa8bc0909197449a1b1" => :mojave
    sha256 "65149d639d145c02ff529cc9889c0a909f776654137ce87cd995361673fed7e5" => :high_sierra
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
