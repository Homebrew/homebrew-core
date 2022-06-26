class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.4/hlint-3.4.tar.gz"
  sha256 "76fc615d6949fb9478e586c9ddd5510578ddaa32261d94f1a1f3670f20db8e95"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245b2f2b7c336f971c4cc76d61c0783990440d1fc6d456f80acdf4ac5ed75d99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "284d0bfddd62fb7b9701d40af5382a658c176b5a7753d2ae6384b1ee081a4cd8"
    sha256 cellar: :any_skip_relocation, monterey:       "754c276f838e043992df0afb6d3cc5ee124b424231b1173cd09e369661bb9b0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe66eea5d9ec45bf4a85368fec60feb60fdc98c99c7ee7e89e2ddc77f49d7df2"
    sha256 cellar: :any_skip_relocation, catalina:       "852ef74d5b7bd71654b6c05c9bfa287dfc7a51c61d9794cbcfcae3291491c6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d27417652ffd657d1e319605a120edbe9ae00e78b5f39ae87d99f9b79e1d57ec"
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
