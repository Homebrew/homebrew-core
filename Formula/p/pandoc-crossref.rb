class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "a276ba571db8912debfc53fddae7cfd686f2c10c99755d55d433721fb3c4e021"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd26f8d9b334b791d5856260dbe051f1d279e0438ee0142929a21ee33626c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec092d6409c1932ff3f7e2e87ddb5ca898939a4409e412f26ab96779a31cc95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28d28cfdfe8c983ef23bbf65e714fd7d54fc9a914d3c757a1ceec628b301ada6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f3581a1aac0cf8c4cc8f4a0422697b5d562cba50fc6bb8c2b452eb10c0e66cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "346abcd600cba40c9e3664f6216c573a86fa271df3d742d2f3a5b2566fa8f90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "718f5cb63911853b34780f0c0efa7e66317e0dcb90eccf0080eb31c5096bd759"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
