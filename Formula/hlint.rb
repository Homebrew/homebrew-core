class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.2.1/hlint-3.2.1.tar.gz"
  sha256 "ae5c0d3a90fcfe64a19abc655cda2027e5b21fff613088e3c4caa3218ad1229b"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a1f6a0ed0b50da65532a125c01896cfa85c88820f6a82744d68ac65340e83056" => :catalina
    sha256 "7de67249019d4aec34ec9c5bed3087138fd952a65b03ff6cd0f1046856edc536" => :mojave
    sha256 "74ab095c18e59981837c686882961d4a393493f5585402499edbba6de7e85c44" => :high_sierra
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
