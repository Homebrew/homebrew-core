require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.2.0/pandoc-crossref-0.3.2.0.tar.gz"
  sha256 "2a0a916b35f0ef4d404e5ab137e4c775ae0067f78bebb25723123b546f7bcd5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a49fe52884f3f1259738b8a9cd54634d1912f4f82b7fb3009b6299a7ce1b079" => :high_sierra
    sha256 "ea81a04f99d887867e199eaa18570795d1a3b09593fbf217a79167d9316c8848" => :sierra
    sha256 "feb966a40c604c34aa1e62eaf8e08f1afb4a87dfb4913249a6eede254bbf2ada" => :el_capitan
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
