class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.10.0/pandoc-crossref-0.3.10.0.tar.gz"
  sha256 "b57db011add318f5626c6e07726c70414f77b7c6c358769c936b7e983caad5fb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f80c36524cf8bf8d91906655ce1cbc1a41f409438d2ace52156f248514d5e750"
    sha256 cellar: :any_skip_relocation, catalina: "9d49a8c6344c23393b923e65e63dbcd638136eac963a81a27cc1a9c7cf073373"
    sha256 cellar: :any_skip_relocation, mojave:   "310963ed719ba07f29e4f1975b11e6c831380a836fe2b165772754542a010a57"
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
