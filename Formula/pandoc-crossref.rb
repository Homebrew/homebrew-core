require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.7.0/pandoc-crossref-0.3.7.0.tar.gz"
  sha256 "467d2470fa66885179284e54d8757ae1a9b442b6ff8af33bd177870f285b85d7"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9355fce7f468cad1ecb3e3684b13baf330f3862243ed952b09da446d2620190" => :catalina
    sha256 "a7fb56b64077f57aa9692758fc1270e65606e695caa85fbaa0ac1176e9cb9bbb" => :mojave
    sha256 "4ff3f56bfe457eef132522a5a721d891fd2580fa47b583f58154592901ccc5bb" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
