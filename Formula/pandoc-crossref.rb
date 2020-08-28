class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.7.0/pandoc-crossref-0.3.7.0.tar.gz"
  sha256 "467d2470fa66885179284e54d8757ae1a9b442b6ff8af33bd177870f285b85d7"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2d2ed664170754a7e59bf66e95676b03fcf4f9a834d7b5793fac4bbb5af5b745" => :catalina
    sha256 "905f77125f0d8cbf99b3395ba7618ecc0206841fa71ed3578f04e8e28c4834f7" => :mojave
    sha256 "d64ac1a85670a2c44f4524cd042a5b9bc90ad524a6022a279d3dac7f9afc3c96" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
