require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.5.0/pandoc-crossref-0.3.5.0.tar.gz"
  sha256 "646ea9b0d1564f894528036724d7a112d54e6946555602cd15c421b48fc301f4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2da24328a336390ba205bfc232a0cefbe93af52c1298d4be5c8819fe7bf1d9e2" => :catalina
    sha256 "4d0cee81d5f7b0c8c3e1c83ca8c03de0ea2374c35e6d2dbd7b5af886db3c61f8" => :mojave
    sha256 "a5ca3bca940585a151ec92280162da834f120d99e486fe6741bec69aa8422c6f" => :high_sierra
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
