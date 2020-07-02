require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.6.4/pandoc-crossref-0.3.6.4.tar.gz"
  sha256 "668e6e51d5977f9c021a1443bce7410eddf2def0696323497d78ffe7a074cfcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1fc9b7e27079de950cd5926404b928ab794fbea680373ff2de879d53e70c853" => :catalina
    sha256 "b3479f76133f44c081c6f3d7aa6ff68e2cba04bee2f83ec84d82b80b2e5d89ba" => :mojave
    sha256 "d71d84afc93ff2099ab6bfadf71cfbc36e57d5262f2f66e4102fe4f5609828a9" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pandoc"

  def install
    install_cabal_package
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
