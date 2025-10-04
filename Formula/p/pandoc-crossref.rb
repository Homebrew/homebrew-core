class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.21.tar.gz"
  sha256 "48f21b868901ccb23654079fc2929500658d3a76252d3d9b86ee11d4c180815b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f30e7d93c0adc0f1e8c7d4eb633c9f00fe6b8238099dded71920bc8b2de5b962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cea5d3a29bbfdd4ce8e8e38ccfe9624f95e7516004fb72cb85758eedeb51f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e883f056baad5a861e3c9840aff2dd54a3b0994d4fbff759ce601b14947db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1cb961792e2b68d1cf9d17ea8254b12778fc95f6bf7dc94a76bb8c530050ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522ca3e0b3deaacd2e47728fbf8a47de9bb04b2372a94f98e5d5657a675925d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca5fddc24467505111f50173faaba2575f0e96c406962e01241e34206217dd80"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
