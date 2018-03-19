require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.0.3/pandoc-crossref-0.3.0.3.tar.gz"
  sha256 "2c2f35497d7df37b8625a93e70982c4d68fcf5a92360809fb546cac2cdd144f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5863e9c46fa492be1b3f690fd1a20ec781c3607edfe44b28c9834069e7656b6" => :high_sierra
    sha256 "42e54077bdc05637e1a21f707a9ffb2d57ed07448d71e2dabf3c0fa17ed0b26c" => :sierra
    sha256 "480dfd80971bca83a1dd9124f5ceec5408a79470e479f2e1e047b73d09898733" => :el_capitan
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
