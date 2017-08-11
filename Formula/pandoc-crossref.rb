require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.6.0/pandoc-crossref-0.2.6.0.tar.gz"
  sha256 "aba0100030daf824a9f459754a7915fd2db74756b11a870e62721a0a08127bd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4926324acbe445b38f9ea4233d007190998f4262f3de749f01ca1c2bbb182d9c" => :sierra
    sha256 "6eb1c30270e4089e1454f5580d80b3a304d1cdadbde028c8624bd410bbc80918" => :el_capitan
    sha256 "986e10b3655438dd3120e3d1165770eadcfc316e99481950b05c4807979d54cd" => :yosemite
  end

  depends_on "ghc@8.0" => :build
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
