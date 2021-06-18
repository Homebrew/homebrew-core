class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.3.1/hlint-3.3.1.tar.gz"
  sha256 "0c3e09b42eeb8e42fedb310107919f5171cab4195d01b884653cc0b76eb9828a"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c16d82b9b80acb360fc4af05e196607afc9234246098002e0d2f1b009aa9416b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b20afaeeda64896bd2c2fcd1e4922f92b1f9cc42d0500060e2cbebd528aed6f0"
    sha256 cellar: :any_skip_relocation, catalina:      "28267b085f5c47b6972b99024b0c59578653f31c47e8c5ece308c2308359337b"
    sha256 cellar: :any_skip_relocation, mojave:        "120e86ad71c28a88889173a5a8139f523c8aaa1c349a56053ef3a6687733e198"
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
