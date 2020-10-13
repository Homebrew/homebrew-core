class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.8.2/pandoc-crossref-0.3.8.2.tar.gz"
  sha256 "6a54e9d5c29b6d74db17c9fb29eb3e2d164417079fccb10d9807f3026cf73b97"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ada32971babb0750bb20b9365f337b938ae8032456fe80a1bd49537fd18a8083" => :catalina
    sha256 "2a6899a14f5ca7baab2e7382e570feabba06b5e15c3565ea5e33f0993fc2bf6d" => :mojave
    sha256 "3520614414daa6bc9454413ef50b9c4b9c790859b82f717950d8fa7e338358b8" => :high_sierra
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
