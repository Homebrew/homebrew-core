class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.12.1/pandoc-crossref-0.3.12.1.tar.gz"
  sha256 "7c54bab0bb45ee68b3110a39b11c4012afe9ddf243ba0745126f0da170e1d40c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bc1d588c2f72a51e5694a1e311bc82f7d6ae1be9aa27e5b8de5c5562d161b2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4e05b0d6a715b76d84a8bfc89875b1f3469079f1d3256a2420ab43ed6b3818"
    sha256 cellar: :any_skip_relocation, monterey:       "de95ee53a12b8b282e3ebca195feb4844b7d3d10f2bd022fccc8f874b86fd7bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a48a94b65a99e2c9af87515dd879ee44a604bf207443a8f4d7d8dafa57d8ad74"
    sha256 cellar: :any_skip_relocation, catalina:       "f310898a96092aa369c8fb97163f5441ca83859872e34c2f74109e07fa2b2cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c1d977fc70a8c02ad43017a8908f83113dbd8b76c83f71af879dc626bb9c9d"
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
