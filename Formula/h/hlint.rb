class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.10/hlint-3.10.tar.gz"
  sha256 "d99672337c06b455884ac14418d562701143141d0d7e46af476817c2ae3efe37"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "8895a29ca2131a788f2ea046e1536014e10814e06db0b20ccf17aac20d4ae44f"
    sha256 cellar: :any, arm64_sequoia: "ac21cffb2a6f0c3e001be4fc90533bbdf55d6759dc92ab6614d8f344e841a5a0"
    sha256 cellar: :any, arm64_sonoma:  "70d59584802f076d591fac5018ab9a9be374ebb40583d70841b0694ec5232a63"
    sha256 cellar: :any, sonoma:        "e7e6690be96877ae75c5628af12084051eb90c602118053265d2f3aa1bb2a66a"
    sha256 cellar: :any, arm64_linux:   "8917cf56b9640d594be9e5400eff427e23a186497f11097fc9d3f19b0f4ba6f3"
    sha256 cellar: :any, x86_64_linux:  "57ecaa7fd8afea0066d2d42d925e402038f5043f45230a4074d7e4078790a50a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build # GHC 9.14 issue: https://github.com/ndmitchell/hlint/issues/1672
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
