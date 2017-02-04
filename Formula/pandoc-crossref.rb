require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.4.2/pandoc-crossref-0.2.4.2.tar.gz"
  sha256 "fe1121698b9b9804f8ccc43cbbb2e77e40948caa543b42e129bf4ce872a7cd3f"

  bottle do
    cellar :any_skip_relocation
    sha256 "da222315b8f7b9e0cc68a7215a54eaf2377f428d0db69a3b72e4c98027c789e9" => :sierra
    sha256 "f5ced83ebce430a8870a6106f1947480124a49891bad0af5cdebc1143c49c8d4" => :el_capitan
    sha256 "0ff5b3b70750f81d8ad96dd3d0d8de5c4afbab60b54a6c38bd1cf0c428c42a89" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :run

  def install
    (buildpath/"cabal.config").write("allow-newer: pandoc,pandoc-types\n")
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"hello.md").write <<-EOS.undent
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    (testpath/"expected.txt").write <<-EOS.undent
      <p>Demo for pandoc-crossref. See equation eq.M-BM- 1 for cross-referencing. Display equations are labelled and numbered</p>$
      <p><span id="eq:eqn1"><br /><span class="math display"><em>P</em><sub><em>i</em></sub>(<em>x</em>)=<em>u</em><em>m</em><sub><em>i</em></sub><em>a</em><sub><em>i</em></sub><em>x</em><sup><em>i</em></sup>M-bM-^@M-^AM-bM-^@M-^A(1)</span><br /></span></p>$
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_equal File.read("expected.txt"), pipe_output("/bin/cat -et", File.read("out.html"))
  end
end
