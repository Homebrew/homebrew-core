class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.13.0/pandoc-crossref-0.3.13.0.tar.gz"
  sha256 "3d001c7e656fba84b3053ce4531766512505c9db1e8cb6c99939f40075eec53a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77964231643f46a4635a0795e9d2816ac69a1f1309349964288104b0e119a749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ca9608656d08bb2968a316d9089345022b2b44760096f4d8af2b050561d08a2"
    sha256 cellar: :any_skip_relocation, monterey:       "87ddf094c8173e17260d25560c364563cc16e1cd7b0c18e22e6ebdfe7f87ebc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6b31f7204425dc3abc47ffb3238b4ab6fa7301f12d60ce54519d70f84a99210"
    sha256 cellar: :any_skip_relocation, catalina:       "235b4bf06e546e450ca45ca4eac14a77f1ec1ed9cd01ee42b8fe29fc937abfb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19b1f7aca5ba22dc52bc7795ea8711dd3383893c0bc87d0ae71b1e88094078c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

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
