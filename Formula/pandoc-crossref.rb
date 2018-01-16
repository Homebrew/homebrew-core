require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.0.1/pandoc-crossref-0.3.0.1.tar.gz"
  sha256 "d62bc57ecbf869cd5777dfc69f3d45722d3be3e691ed4e47841aa656df5c1252"

  bottle do
    cellar :any_skip_relocation
    sha256 "f19dc749bc5d4d4e6b6302452cccba484422c8c293cebb91562395c27f1668b2" => :high_sierra
    sha256 "2e0413636cb89ce886f2a87df2f48558a40c6e4eae2e3030581c89a52d5eb31d" => :sierra
    sha256 "b59330bd828f0190ffdc645d5939652536a91dd7d91f088b0a88593f8003dcc7" => :el_capitan
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

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
