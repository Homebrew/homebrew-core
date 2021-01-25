class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.2.7/hlint-3.2.7.tar.gz"
  sha256 "6f9c3d9603a072e1b76d3ee125dfaa54ce356fc0ced836affa741d989bedcf7c"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "537e2d46565c5b6799d5b538927741020c3422cb48eb81ce453180791fba03aa" => :big_sur
    sha256 "75d3c4a1ce18ec83dd7e02033b44d2c7d9086b70719fed008e02c6d552e6d03c" => :catalina
    sha256 "16397d3ee6601a82fb75ae4c58d57dc65d827a86052bd85d9a07f22edfc5a465" => :mojave
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
