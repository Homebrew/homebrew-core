class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.3/hlint-3.3.tar.gz"
  sha256 "6dad2afb040f9fa49daee924443c7cd14cf43836ec59ff277622da19075775b1"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "824195c4e13ef2cf8f9a95a791ca7159bb1a576fe4e28768dff7db7e5d1e5986"
    sha256 cellar: :any_skip_relocation, catalina: "af3671cbbd2a989cc6fe386e1040c6284acfdffbbf474bd5063ad9f5b9984895"
    sha256 cellar: :any_skip_relocation, mojave:   "dadf6ed60bdcf3837ebd280bd7a06b95f1e58de6c2f896923eab17f6599c847c"
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
