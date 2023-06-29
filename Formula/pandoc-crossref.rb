class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0b.tar.gz"
  version "0.3.16.0b"
  sha256 "3c9bd9bafa229f67a340575e572274ce11366e853b0616511dbf448a4e452a77"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3597f92779c29a7b00acf943c81e7d414342faa080c9890501fdd62f9abb693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b482312d6ac8cb9f21663f62f0bf395e2e0bc9c24eb7f50451b424ce322919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2225c11c63713c3c5fd3a3eb01dbb84db200e2a3a6c1cef30d53ac125920a7a0"
    sha256 cellar: :any_skip_relocation, ventura:        "5b0bda5ecfdbc85fa6354b3c2189eb4c9742b203e78fe0152f33e95bd378a466"
    sha256 cellar: :any_skip_relocation, monterey:       "9a6c7170985ec5fcd28c957a17ddb6f57925069fdd5a7814d7d35a416c909dde"
    sha256 cellar: :any_skip_relocation, big_sur:        "e57d308f5a135a18ee9af4d1b39b8613563ec9958d4a17a0fff093df46a92848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aabb6170371cb01e8f1e2d5125d22b8348b7ef7e50cf0857deffcb097a4485af"
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
