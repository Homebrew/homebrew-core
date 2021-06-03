class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.11.0/pandoc-crossref-0.3.11.0.tar.gz"
  sha256 "13b242e408dfe6dc92c868f5025626b3e882b31d9fd22e635165dfd22f29ffb3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "42d899a340c57df84dad28e52a1e3eeb91520c6842be17bb6fe29ac99b5cfbd8"
    sha256 cellar: :any_skip_relocation, catalina: "ad0bee2803a212f0447be6071d64ddfb83a89265e82fc225d18bbe06e5467167"
    sha256 cellar: :any_skip_relocation, mojave:   "ba49887843f71a964526ae9d00101250c77fe8f80432f92627dbde5b37640243"
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
