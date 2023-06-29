class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.6/hlint-3.6.tar.gz"
  sha256 "d16ea7a3130ebfd8a94d06a28c87c106c2a59a3c0ae8ab6c2a830498c99e4138"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1445d91303bac491426c89a082de7ac34b57f24b55b6eeac488c32d318245f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cac3d84f961ad425399ded17beb402a7a26bbc42ee1db594841d31eeba29eb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ee6442e9cc573af2f3ebf521c2f2c97a040495beac7627f140dc979cca18dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "4f77327ddd1d731ee1f705aee40198fa844bbe5c7ff0275856e478d2e0587d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "78eef9bdbb0eb0079ab06bca61128ee542d468fb315b6019dc0e162b0e5d29e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "72115617df76eedebb6f1543094b360401ed1433143fd6cd3b5cc4f6d3065d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33dabeb9b47469257eecdc81805de3702ed6e4edc07eedeb39703bda7e9d77b8"
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
