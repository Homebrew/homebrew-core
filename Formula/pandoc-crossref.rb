class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.9.0/pandoc-crossref-0.3.9.0.tar.gz"
  sha256 "88883763f9b73e17538edec6ec05eae8119a3b5b5a473bc8183e2d42f3df1da2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "158403ac3436da6fa1b74493dbe83f2d953438c5db16524ff58d81a9c619c8d8" => :big_sur
    sha256 "a20fe29a6b66f031331ee3cf1bb5f0f33a9ef7e501ea18ebd2575e291fd63cba" => :catalina
    sha256 "f23ddb7c3e1082203ebe84c084e4e13a769efcfbc6e2acf86263459072cc3a7d" => :mojave
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
