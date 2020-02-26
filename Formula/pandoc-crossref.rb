require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.6.2/pandoc-crossref-0.3.6.2.tar.gz"
  sha256 "85618a03ae58ee3cdb20474a0ccdff4e2f9374b76ea5f7334bc90e9de372ad14"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b1fec13c16e3413e8c258a43fa6757b7b0e893e691cac5f38bcf6bafdde0b20" => :catalina
    sha256 "f71d29851bb8b93fe37a16e0efc9505d2354b15c14aa40f2a84549ec5631ad80" => :mojave
    sha256 "1de9cb64307983b03592547cdd61de15e72822744bca6cd2d8abc645cd51fa4a" => :high_sierra
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
