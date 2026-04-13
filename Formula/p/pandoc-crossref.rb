class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.23a.tar.gz"
  version "0.3.23a"
  sha256 "7b3638c8b8d416f28e950cf650c52d3e961f53ce6cc640133caf8ee99b2efade"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9b183c44cac850fb1b9fed061f569e237aa661897ebde73b25fab4dcc680a2a"
    sha256 cellar: :any,                 arm64_sequoia: "5f5b1c921a1ec12673fed139bc30d0081a9e3907576924b37a99031e6b6a4ba3"
    sha256 cellar: :any,                 arm64_sonoma:  "7cd1f3f54aca0e4ca23b0763a767dbf6954e616d8476ad487305c44cce44a435"
    sha256 cellar: :any,                 sonoma:        "d372123947b5b6ba2e2855d54698d05cca6834c79d05aa02e93948a973dbc3a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d364ba6b6b1ed44f8420fa662a609c156e111b13940842fe445dbe8c61f214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c968d8b3f4e2fea0abf4d45e88de701b529de113e77527fd155313712faeb505"
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
