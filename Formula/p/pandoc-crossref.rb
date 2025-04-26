class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.18.2.tar.gz"
  sha256 "a7b95fcf6807c3092684cf622da87afa34df3c2e6655a20dd5c243390f5e5ffd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c31c2e8d6cbf71a6471a59ff0af50309109f69600f0ca6f9fcb0faa0b8c973d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3f7c2debc407d04db35dc18f24f9dd1bb7c61b846d8d50755e664d42e182a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b767c8f3a07c9a70ef21be148c4691908039322b7e4528b211c6a03c53bc9528"
    sha256 cellar: :any_skip_relocation, sonoma:        "912f9f13386e61b1ce6102dea06e376cdf09d2bbfddefe5c6316cb3bba864f57"
    sha256 cellar: :any_skip_relocation, ventura:       "ec217ff88096135b8f1dd5fb087a9467ed54941fb0b72b758cea1fe66c61adfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f9f4fa3294746fb739276dbcfa0eab29ef9ccbb3e1ecde907199d1df45e751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ff2b5d1c5379da0b17cad7ab5a0b241c38c76042497148fecc6b8bba76c095"
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
