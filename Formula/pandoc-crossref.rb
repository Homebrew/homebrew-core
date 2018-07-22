require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.2.1/pandoc-crossref-0.3.2.1.tar.gz"
  sha256 "86023c1df83d1375eb8620ac4dcd91a3be581349bd91d802a63fc4ec1eb6b167"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f282d0c583bf6b6a66972d653980c615e172a4f076b39ab3a31d1945c187ef2" => :high_sierra
    sha256 "ee2b34d681026c77d7415d66e258254d5ce8d9ab7562cd6b21db93fec8b832ba" => :sierra
    sha256 "53e9ec314ee9e35f100d1d628301079354308b2cd53eeadae3bd3bfaefc402e5" => :el_capitan
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
