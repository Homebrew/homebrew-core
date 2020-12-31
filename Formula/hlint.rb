class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.2.6/hlint-3.2.6.tar.gz"
  sha256 "e5ce88ee3728632122b1f93ca733cad8d81e0833da3244fc1dca356c22c638c4"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "372c36bdb7d3de1dcd58c834576b47cf7a9b4e1fa69d2d1566efd6c56984ff6d" => :big_sur
    sha256 "7a21f5da92bc3517c2d79bbef3aa53cdccc83b60f08767e2f612a1aabb31c6de" => :catalina
    sha256 "f79c9d626e6717304c3bea435989e447fe8489096d727b75c227e893b4aa79de" => :mojave
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
