require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.6.2/pandoc-crossref-0.3.6.2.tar.gz"
  sha256 "85618a03ae58ee3cdb20474a0ccdff4e2f9374b76ea5f7334bc90e9de372ad14"

  bottle do
    cellar :any_skip_relocation
    sha256 "d574e3b2fb5485e825af1a257983ca2dac83b46434ce0c940a5dc09d4a45f8d6" => :catalina
    sha256 "a0bef9bcf61fbbd62c88683516ff726f3ebb8dc9f02d8094d3fec77f6bb0fde7" => :mojave
    sha256 "67e728eb2af9d4fa3a508137f72b7a273818dacac6aa84ca0704e46b726006c7" => :high_sierra
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
