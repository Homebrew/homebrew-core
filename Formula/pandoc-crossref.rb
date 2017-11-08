require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.7.0/pandoc-crossref-0.2.7.0.tar.gz"
  sha256 "33c94dceb535a73462cbb86ddb778119b9344c2aa834970bd115c57345f409da"

  bottle do
    cellar :any_skip_relocation
    sha256 "18cbe91fd66eecedbf9e43115add141ab4c266c83694b9dad7dd4ebc93e32224" => :high_sierra
    sha256 "8b8917ffbcdd7fae1ec9b7efe867871650bb25b39263207569ca60325c09f9f6" => :sierra
    sha256 "50da260a3cb0cc47d14fcf161fe59d88a8e84e63752b112e4d4262739ce2af6d" => :el_capitan
  end

  devel do
    url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.0.0-beta.tar.gz"
    sha256 "a1eed2ff4f5cad325c72cbf9e2d3b2a64141be192dd94a992e62727d261370dc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :run

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

      $$ P_i(x) = \sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    (testpath/"expected.txt").write <<~EOS
      <p>Demo for pandoc-crossref. See equation eq.M-BM- 1 for cross-referencing. Display equations are labelled and numbered</p>$
      <p><span id="eq:eqn1"><br /><span class="math display"><em>P</em><sub><em>i</em></sub>(<em>x</em>)=<em>u</em><em>m</em><sub><em>i</em></sub><em>a</em><sub><em>i</em></sub><em>x</em><sup><em>i</em></sup>M-bM-^@M-^AM-bM-^@M-^A(1)</span><br /></span></p>$
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_equal File.read("expected.txt"), pipe_output("/bin/cat -et", File.read("out.html"))
  end
end
