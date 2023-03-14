class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.15.1a.tar.gz"
  version "0.3.15.1a"
  sha256 "9ec2522fb5d13a4e6126b2e61631a4db4329d0576d465c516055fdd1653ca958"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5324b7d2d9d2a2784905602e7dade81a1430ead045bf69d76d5c0579c6fc1ff2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de67d21cfe4d934991bb7f9aa181a7ce256200482428ffc2fe16b5bc59c8953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6810a15063a3e5d80945bc8180645c1435d4327e9d5b3ada7065c77000343d0"
    sha256 cellar: :any_skip_relocation, ventura:        "66ea2b6d87be81d1edade12c525dbd55154f241eba016ae9f0749830b151a486"
    sha256 cellar: :any_skip_relocation, monterey:       "34f5d8983a77415b70476dd2c58e17afd976d09ab387053c685cabbd1a2a17ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "05692f43632d048724d36850b6e102734df8fbd0c17c885eacc39f3a55c92d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b82ff96d204feba68c6c1b02fd6d24f72cc178927f230d88a68849cbd7621f"
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
