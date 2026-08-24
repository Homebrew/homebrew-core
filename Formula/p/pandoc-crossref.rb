class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "cb42b8319a59f258fea191e4660b62bdd9a90a9099322ae0f17203bc5986498a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "866aa0a29786db950b528e19151f6638bce273a5cd40c1df80c477feda0b1932"
    sha256 cellar: :any, arm64_sequoia: "391544a14cd89f253ea4c968d8aa4b6fb92ec0e9c896e8f4bbb415a2874728dc"
    sha256 cellar: :any, arm64_sonoma:  "259da75e1c909ba68d6d1c275afe75923f5b06cf46adcc117a4eead17e42759b"
    sha256 cellar: :any, sonoma:        "bf616685c61af5d7f3f268942703b3ddf47717c74b01faee1c3e89a37385bc98"
    sha256 cellar: :any, arm64_linux:   "12b38b236f67baca69ea4c57d4ce16bea8003fcf39927cb1289a6392a845b528"
    sha256 cellar: :any, x86_64_linux:  "e1efed30a2df80e82222bb9fd57a5e3daa7b80ecd6a18b97c58953befaec25ac"
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
