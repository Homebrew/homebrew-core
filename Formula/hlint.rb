class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1.6/hlint-3.1.6.tar.gz"
  sha256 "dd420c3da81837bfe65f2de2bf9adacec0c9964a0783d2c5f224e7c1f1907fcd"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f276a6a6880e8bd6496f6390c337b9175acfcc16a1c4cee56655fa25858e5d20" => :catalina
    sha256 "3c6ce1c19c2d13593ce62fe077678c5901a4456eb1d0f3521f6d55df15f48fb4" => :mojave
    sha256 "0bbdd97f8227feb367c81857012d5df4b0eabb895dea7585b029bf99c05e5756" => :high_sierra
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
