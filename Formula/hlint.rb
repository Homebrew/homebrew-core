require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1.6/hlint-3.1.6.tar.gz"
  sha256 "dd420c3da81837bfe65f2de2bf9adacec0c9964a0783d2c5f224e7c1f1907fcd"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "881d3e4daab949cfb57c548876183141ac148f22f57181f597c0c7ff87e68061" => :catalina
    sha256 "33554acba0caa916bcf31fe2d33e507794a3ace7253a0c947086b7b29863312f" => :mojave
    sha256 "4a70bd3abc1bd6f7ffb055e9f66e5d1e82b003b5f4bea39e116102dc2dcec1b0" => :high_sierra
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
