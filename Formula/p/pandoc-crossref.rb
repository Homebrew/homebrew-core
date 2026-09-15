class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25a.tar.gz"
  version "0.3.25a"
  sha256 "91712810bf91807869dbda35f5186cd4f39352c6201d5712c8f4ce1ac3691ab5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4a4e1b6d9652ef3e91fa419d1f959bedc7e11fd023e2e75be4642841683a03ef"
    sha256 cellar: :any, arm64_tahoe:       "65567325efc7a6eb28cf5506ecaf3c44c3865d1d04b3898863c54b8e6926f920"
    sha256 cellar: :any, arm64_sequoia:     "c32ff566e178ebe701acd0e805d18c956e0347aa2b2281963ddbfaffa51a7da5"
    sha256 cellar: :any, arm64_sonoma:      "c2df91ac73bf8668a8436d0037fb67ac959d51048bcec02b1bde1f4955c8addf"
    sha256 cellar: :any, arm64_linux:       "994e80c28e87596b96a098c15cf66ff54ef3c4b5b31d8a40297826050d070683"
    sha256 cellar: :any, x86_64_linux:      "ee0aeaad2a8b0f09e4df07f4ace15d7d288093c770e6a8b3198825882733b1e1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{formula_opt_bin("pandoc")}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
