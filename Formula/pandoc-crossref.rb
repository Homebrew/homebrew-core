class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0.tar.gz"
  sha256 "4ca050e31019c43ce7e4e0bae77973cea01d59e0612cfa945ea8d6ce3268931a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b8af7eb107c55ea9d5cc0e7cee6fe2118cb3cdeaabbfb8b07ecd111293bc09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7cc5197e8eabe2218a50306c3893a62ef081e0431943e230eb13f1280208f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42a172e9f6f2386ea8eb27a6fb10206ae73b7f3279292137b8974dea76c380be"
    sha256 cellar: :any_skip_relocation, ventura:        "3647eaad66084bc1e5bb22c7d22ab71129251761f777d6def076c7b27737c18c"
    sha256 cellar: :any_skip_relocation, monterey:       "d958241fbde5152c5508894bc454a4451fcabc8967dbee58d7d8197a8a0fda5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae5e75730147e3ab191eccd3957751d0750ea929ad7ae020bcc5c35484253db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9371c90dd2229f4b646041d9ed61529e6752519b66f0304acf25e4c0434552b7"
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
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
