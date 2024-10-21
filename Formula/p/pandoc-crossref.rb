class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.18.0b.tar.gz"
  version "0.3.18.0b"
  sha256 "a71043e86104951815886d560dd1173308bd7f7e556ce80530b4de03c1bcd9a5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "454b100be09864162dff118c2490ec0e0bc597e2d832f926510ffe4486a98221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a942e0c90660465a0b1dc9e5b509336e9beae20ee7b1e94ffdb8fc04e69525e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efc0398a828f9c0bdf9637244423aa7b7ad6c98aa2d1b64d08a8013c255e5cac"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c7a8bebdfa52ce8ef133cc14b464fc5ddb7a1ae60e6fa156ec3992aa2bfb711"
    sha256 cellar: :any_skip_relocation, ventura:       "f756208d8a05afd7332cc5fb2872bb4d2358b0bb76c63bacb4ac9cc6eb4e8f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b421075b72824a3132beafb12730eaebfbf1dcd907eae0e89eed3ac1ed1468"
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
