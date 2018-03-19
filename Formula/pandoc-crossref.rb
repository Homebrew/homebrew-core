require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.0.3/pandoc-crossref-0.3.0.3.tar.gz"
  sha256 "2c2f35497d7df37b8625a93e70982c4d68fcf5a92360809fb546cac2cdd144f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a93dd7e7af6b4a72a64c5d079c832772741c47b1e8200b67d30b69f0a38a96c3" => :high_sierra
    sha256 "cc6a31b4c611eb340ff8904b741b66437faff9a8094bc62d3bff7ec1a941240c" => :sierra
    sha256 "af4cb0a52118ec53554ae5b93f28f4a4d8108dbdbfe6463ac927a2fc2561fc18" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
