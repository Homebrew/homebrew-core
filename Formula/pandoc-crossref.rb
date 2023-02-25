class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.15.1.tar.gz"
  sha256 "2a67663496a473ccba66300dcd9ccb0457b7a55105446975dd53b78822940407"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5591d300c898f9d4a5b40e3dab2ce27147bd72251077e7b6b73376a1fa4cc662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30fcbb23f6527a9d44f456f44c186a446468edcb8bf14d7df5535242f5ad9fc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f796a9c9809df40700fb2af46a009c40f135314d4392b44751c9cb81236f6838"
    sha256 cellar: :any_skip_relocation, ventura:        "b87c5ce5d372428a81b2f3052e2d67d0fd89a6f8ecc08ba7eeac3059e8896629"
    sha256 cellar: :any_skip_relocation, monterey:       "f32ce47d7730d9f5427b4c88c729b7aca40a3d7566608ceb2c9a08fe4381a239"
    sha256 cellar: :any_skip_relocation, big_sur:        "3daca1c25e801e07d99e1150500dc4d0da1cb8c04abebad6386338d38e8a73b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3ad93c79e05ba06946cdd19bea2cb1954c880957c9decd1562b662b111c96a"
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
