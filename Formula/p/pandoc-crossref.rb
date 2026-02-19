class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.23a.tar.gz"
  version "0.3.23a"
  sha256 "7b3638c8b8d416f28e950cf650c52d3e961f53ce6cc640133caf8ee99b2efade"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d7df4148706fb1cd56efb60d5845d4c1a36cdaa18f9a038e6e1880a911e9b03d"
    sha256 cellar: :any,                 arm64_sequoia: "975d9a6fd34e1a09bf53f1fc928ac6b67d0c5b19c4e78717159784603dd07bb0"
    sha256 cellar: :any,                 arm64_sonoma:  "399b45bd36a3b4f8109fcc515f28531f4423d85bd5445956a9e412c4469abf39"
    sha256 cellar: :any,                 sonoma:        "f0a48dbbb509de85612054b32a7392c8f7bea7f5dcfecab0fed17d2cb13c7d50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cb7b83d51633cde32f701ab5fcca0e3081c26f7dd27b83a3d10376c793c271d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b1eba3b664d7729513dc25c9e432efef4d6806e1c2a6ffee47dc2dcb088365"
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
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
