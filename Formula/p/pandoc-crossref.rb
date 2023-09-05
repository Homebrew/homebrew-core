class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0f.tar.gz"
  version "0.3.16.0f"
  sha256 "1239cd17197f6685bf29e842d02618d0d2fd3220a469970f4200af5176638515"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef1d506aec5f2d3f74d90a9416bce5d25241b738496711c798849435a2b058b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d379ae4eb725daa6dab81b99d49c333db64ec2b50689dc2119ecfbca43c89908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48a544f3b00f614a6b0fc5d65c51900f7afaf669bde9b20b8640fe26411fed17"
    sha256 cellar: :any_skip_relocation, ventura:        "7e34bdecdf5868b72540587d84a09c4d0d8c66ecd7f2045d3d0f474e65dfc9fa"
    sha256 cellar: :any_skip_relocation, monterey:       "2f68eff7c9ac4ef855b8201ae5b232c123552ce67441d3a8711a42894e2ddfa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b06fa49553713ebbf986533d7188055c065c0b894298df03429847657423ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fa6ce0c9f01761989cb39e9b9be9b987de975c079a74eb57b32dc4272ec33f"
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
