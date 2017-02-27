require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.5.0/pandoc-crossref-0.2.5.0.tar.gz"
  sha256 "d4d93bbe448e2cf187a0b7bcc605d0445e28021e4e31bfef890b93bee2b28491"

  bottle do
    cellar :any_skip_relocation
    sha256 "246c50fcbe2b928a3954bb03940243ab870c5a2c548729b38901eeb50ea3c09a" => :sierra
    sha256 "dacbf5dfda260881d010419eb517037bb6e6023e6bcdedb8c3cc4a870308c51b" => :el_capitan
    sha256 "7771b5dada4f793f9cb5aeb36c59651ad9fa3f224700c95aac06deca3c9c1ad1" => :yosemite
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
