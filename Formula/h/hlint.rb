class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.6.1/hlint-3.6.1.tar.gz"
  sha256 "3280132bb3c1b39faa4c8c6a937479d4622484914da6a227a2ce4b15a76741fd"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c423840eab1c1fd700b28f36c0390645205e457124d92106f4ab96d27241a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1920a480a6250021839e664921758424180031f5c335d146f9038bf2b02ffcf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f114f09cdd743960edd0e7fc90e712802a4a9110d726c17d25817569c27100c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c4e4d69975891296a8981beed3506777eab2219450ff39c27ac5431ab3ec3e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d6bb6744ea13f7f3e6a00d7b6fa169de7f32d7ba818b4720794f1efacb6141c"
    sha256 cellar: :any_skip_relocation, ventura:        "d990c82e9f6e8c750768514d65f643eade477c3cc78c3c5e76aa25ccc57bb7f7"
    sha256 cellar: :any_skip_relocation, monterey:       "7924dc02cccea176a7d3c01d992730de60943998dd9deb32a428b0b2995b0cca"
    sha256 cellar: :any_skip_relocation, big_sur:        "71bac220d493e17d68492a8671ebac958f57e0080e90c364de86a558f3963ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f7c5083d6b6e4e918f094d818b648f580fde9effa4c7e8b62e00c7867f5f37a"
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
