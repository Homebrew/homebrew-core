class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.10/hlint-3.10.tar.gz"
  sha256 "d99672337c06b455884ac14418d562701143141d0d7e46af476817c2ae3efe37"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80a07ff5c8c5bdce01b738119532b94fc47e3334e5d9e355a22c27e1653a4c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f3a91f79fe82520ad8dfabefbce65bb2ea46b6204b4502f273e77c25ad6506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5145bf4f71231257b00c87da12917717656ef7ce2cc3b0ab34ab0eda2b27c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca888410bda893835a17d6b612b1d81c6b27c3b7d48a8f3c235b8300bde6211c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fabac4ad28935c5b1f84a5e2ca98e3e5d10ad97bd3ef4ec43df68e13be4236a"
    sha256 cellar: :any_skip_relocation, ventura:       "25bddf78c27dcd1c33697450946158fa12af8f8a487c38b906490878e4f8c3a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e138950b30faf4adfc02f70d7a9e61c34ff51bd102ea11aa63da02d8706d4955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2217e05a4e5a0fc44c950f63111bcbd4bd48d2148fa95ec8820a7f50f9a5ea6e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      main = do putStrLn "Hello World"
    HASKELL
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~HASKELL
      main = do foo x; return 3; bar z
    HASKELL
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
