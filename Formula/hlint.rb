class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.3.5/hlint-3.3.5.tar.gz"
  sha256 "812218e0e3eeceebe9ba8c9767543e2381ae163dafc81a762274951965493edf"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a8e72dd1f1e09edacc8a2f3461d88f732304b10b636b5d5e768459cd588c1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a72f246cb52967448022fc74a4c85ddf23f71eec3eddeebccc85a37a35a2651"
    sha256 cellar: :any_skip_relocation, monterey:       "c115c34fee6251833f5490b5e6340b47ba73f25ed0020a5be188d3e95528f466"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a5d32a6917907fbc30cc836158a893480204494eef7110aba8766bbd0b05b82"
    sha256 cellar: :any_skip_relocation, catalina:       "4234748b2ed2be41af0163147e2616c51801b791e6bc9671413469784000d8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543ad96663bb904e65bdeb784bf8c49c131ee39b364e66775964f074ad6727b9"
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
