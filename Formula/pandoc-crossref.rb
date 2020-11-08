class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.8.3/pandoc-crossref-0.3.8.3.tar.gz"
  sha256 "5569fb4449e619bc3eafd6e90a6a618622fb6713d3aedc92c1a38b87c218d474"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "723e2b9c88b96513fb9f1eac0d45a87723487aff9d5e3063e6023d4843de537d" => :catalina
    sha256 "6595989164be9000d8081f2908f84642f190084fd04f8cf6dd0ba61a4ec5b657" => :mojave
    sha256 "5c0b8fdda9d69df885f037596068d30e2271e44fb1e45452f32d0132910a3a3e" => :high_sierra
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
