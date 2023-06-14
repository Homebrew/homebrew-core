class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0a.tar.gz"
  version "0.3.16.0a"
  sha256 "13c34b1f8b0a31ba297dc047eef8658348d5184eec6f0ccacb9267968129ce39"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92d0cd837805c1258a6293076e479baf52ce70d6fb5ccea6a11721559aa39897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8a1d296f55fcc378601321859db0468bf04a97656d5c49ffad300ddfee9a35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe33a56741e1bc5ea47feb3ba389cd9e295c1beb36e1237ddb2447fae98bb9c"
    sha256 cellar: :any_skip_relocation, ventura:        "6c2ba67ec48b19a1e17c1e2418f8df63534914ed5f27012c5bf1b1a73b55d046"
    sha256 cellar: :any_skip_relocation, monterey:       "a798b5da13f14ffbc3efd6ac4eeab5ae5107bca5eb06bfbdb3450d6804351ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b17f794f28e7b4025ea8e4c111e683d24dc19f05ad3847066d5d7252fef66eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d00b913dca8103a634996c23335d3cbd05f9fbec2bcb86c2f2fd6604a6dec8"
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
