require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.3.0/pandoc-crossref-0.2.3.0.tar.gz"
  sha256 "b6b4200023da4835cf50a2c9a247a837282ccf16e1684336b5a15d17b9ad085e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b6447107fed92d75fbe0ce31a351cf85a674e0e7ff8e1b08da38ebfbe6c91a0" => :sierra
    sha256 "bee977a4bc2861826eb672e547cd36f2acdfdaa7a3bb77866a39d290282cbc42" => :el_capitan
    sha256 "9b730624d3944047f30456e9cd4dc1003facb8cceab2f258f3ff771c36b0d146" => :yosemite
    sha256 "15e58c2491305ca1e97c3276964c123171c1a181fd0efb3eac1ab2cfbcb49bdf" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :run

  def install
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
      <p><br /><span class="math display"><em>P</em><sub><em>i</em></sub>(<em>x</em>)=<em>u</em><em>m</em><sub><em>i</em></sub><em>a</em><sub><em>i</em></sub><em>x</em><sup><em>i</em></sup>M-bM-^@M-^AM-bM-^@M-^A(1)</span><br /></p>$
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_equal File.read("expected.txt"), pipe_output("/bin/cat -et", File.read("out.html"))
  end
end
