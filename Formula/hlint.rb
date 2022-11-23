class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.5/hlint-3.5.tar.gz"
  sha256 "98bd120a10a086c17d6bf1176a510dc12b36581e5a901f1e024555bb3ccead4f"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e90b3c512ac6c5489b0effd2b49ce968d28a18602ef867b442af8d520404d66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86b42cd45b1750a33a6663f9133a569c02f2b5ce68afef26ab74ac30f0f604ec"
    sha256 cellar: :any_skip_relocation, ventura:        "d4585fac9a68e82fe5fb2139c4690dcee8a87260cb8432b6b64d0d4588464a89"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3bd5dc47ddf0444490cf619dd64f01d1570fd058dc246fdb8de5fa99c73c23"
    sha256 cellar: :any_skip_relocation, big_sur:        "56014f8e39dcba3cb9ef0e6becd505e40987b80b0c24cb648a930c653153cc60"
    sha256 cellar: :any_skip_relocation, catalina:       "5bcec467d194253ae30ae799b1a7d20ae334dc4905bd38490541eb7ee0fed660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30444098936f17b468eb10fda5ce5201b5cdc6663c9f8fdac29e7afe992b7cb6"
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
