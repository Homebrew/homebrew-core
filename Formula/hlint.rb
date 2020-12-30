class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.2.5/hlint-3.2.5.tar.gz"
  sha256 "a41b5ab8b844e56dead07f83475f1d8a65832349ff425bb0a6c2f9c8b525723c"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6fdfcfe8477ee9e8cd486931df5ecefbb385550bb5098e16bf7bcf985d3a1767" => :big_sur
    sha256 "3ae3bc2582fc2799f345778d5bd9e8e884192fc2c5b854c38014eea029190083" => :catalina
    sha256 "be1a75e267e36020847d93dbf1348f4263c135e25a292324795699fea70fb4ec" => :mojave
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
