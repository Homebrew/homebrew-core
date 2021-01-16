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
    sha256 "09bf35a7536ba88dad0e855c3e8fb1e05081b113b7c02bbe43c0d17e26b40fed" => :big_sur
    sha256 "c9c5cfa9eb6b887da399329f4dde012baf80f0f9de7ac0223c73e2893a258dfd" => :catalina
    sha256 "f91c6b3302eca89087c29e5e6b961e51b1024e139a7457ee674877e334f1824a" => :mojave
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
