class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.9.1/pandoc-crossref-0.3.9.1.tar.gz"
  sha256 "9d03ae20aa69d3a7cf210cd615bd488ed08951f795da68905fe6ca5f57a0d54f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5891c1b921930e25fc5a30e981b28cf4832dc39723563dad57dcc8db5f1bb0e8"
    sha256 cellar: :any_skip_relocation, catalina: "01c2b6e311a371ad320c4bce5b022a3e126b109e7dd33ee48b18fe713b8e1018"
    sha256 cellar: :any_skip_relocation, mojave:   "f5ccae410ddf413d74ff4e53add557b20df7749d423437bc91ec9068d4b8fef7"
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
