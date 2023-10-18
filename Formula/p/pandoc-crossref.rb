class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.17.0.tar.gz"
  sha256 "a1933b7aba27ef352b7624d234980dc4c4b46ebb607e940c669c2a187e6c6426"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09b0cf57e41e5c035985bd3694e45562b7d2c3ee74c24c2d25b7ac7c2b49d4e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab58e848293f827cd3c5de99ee405dfd0a326fa04c1c1c6fe2b77f9a5326227c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1889a0a6ed0612db784cd64bf795c7066fc644bd1fa68e3bb7e9cf595481b808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb9a1945b4cf3380ce43d123e8d9be80ff4c17a2b63f9fb00a196ea11f6aee2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "318e54e4c3c214af58de7642462e90ae9072bfddc9b07a4dd8341cdfba7bfd04"
    sha256 cellar: :any_skip_relocation, ventura:        "a783f5ceb91e15d05270af04791495dfb9ab5383ec034764a2e9ad280a4b44ac"
    sha256 cellar: :any_skip_relocation, monterey:       "2404e8b595630ac17a6ca33ab68e75116e919ecc94209764a3eaf2e59f9f84ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "09ba64cdad7851d8e3f5a4d6cd48c5898d62670e4f3c598c4ddbc3ceb81ddbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9457e86268192d9b5224d9c763f64ca36af589b197482a98703a66debcd95985"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
