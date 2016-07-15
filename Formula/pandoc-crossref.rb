require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.2.1/pandoc-crossref-0.2.2.1.tar.gz"
  sha256 "85da5dff663b578367ed75dcd71d8273a9cd92e8ae4a907ff0b83694d8417abd"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a708dfc19637fd44bfafc9b117e691a0d97fbdd489316520cb966d6b6857cef" => :el_capitan
    sha256 "4522dd567ab6af5fc7aeda6ec24f18968abe6482b6ac9388446d19a5c10db898" => :yosemite
    sha256 "eaf8f4f2fce30d9b7e8a5858c5d4b75a9e2d9db36acc9b312c23082eb38ca122" => :mavericks
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
