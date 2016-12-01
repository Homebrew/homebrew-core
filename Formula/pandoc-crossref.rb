require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.4.1/pandoc-crossref-0.2.4.1.tar.gz"
  sha256 "2aa2266ac3916677c18bd9a88b99f32622c22c983abaed3598020913ca3912ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "67900e8d27ab55437f56788e7cbe2a063132e7ee3972aa6740cfb86959711ed6" => :sierra
    sha256 "3c2df28ae93d800f88c49d058060d5bcb4b26cc7f20a4d11f73fc3968e207e73" => :el_capitan
    sha256 "cdbfe9aeb3b9eb7826e4fe56b94d7e3ac14249562dcb1ac5d48fe5bbb8a0bba9" => :yosemite
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
