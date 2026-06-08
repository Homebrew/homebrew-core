class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.24a.tar.gz"
  version "0.3.24a"
  sha256 "5b478c94b67d5b972c7b3d867a345be982d3af12475e2261dd9b37fc17e225d1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56885d16e051a5355f5fa2168e3198444406008b28bfbc6dd7425cc6a2b61e33"
    sha256 cellar: :any,                 arm64_sequoia: "d022df5a62df6a7608a3fc2621bb5816da9c59f99b628336fe51f0f07d01b8a9"
    sha256 cellar: :any,                 arm64_sonoma:  "88d25d295ba194f8cfceccbc80b4bb8d0364040b22ae0e894c7dc909ebf19041"
    sha256 cellar: :any,                 sonoma:        "d6f51b871ce894c7f23d0dabb58588da549c9c50f935de8a0f5ef672838d863a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595206134b10f581718fecfceb92825addab0c42ae886a8acfc39da34180804a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3230f07ffb12be2a6c559df5e531243ffcd22e62080939e4a906bfad712a574d"
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
