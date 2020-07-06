require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1.6/hlint-3.1.6.tar.gz"
  sha256 "dd420c3da81837bfe65f2de2bf9adacec0c9964a0783d2c5f224e7c1f1907fcd"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a385bc86bdad4e1e59180e844b1f6371577ca05e17039094988d2c404ba9b769" => :catalina
    sha256 "3e395a8ccaded15d81e5e970b4347a2484669e9cdd5ab27373f224297af090aa" => :mojave
    sha256 "cba025cfb5157f42fec2fdb4e3ef6fb798f44e9daca5e1a860a722931a5c5f6b" => :high_sierra
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
