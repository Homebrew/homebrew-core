class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.26b.tar.gz"
  version "0.3.26b"
  sha256 "c4f3cba662ab5e66a0f3081ac88ecc03b4eda9e2319a4afda1a77fae20392b47"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "74cd8696e6620b2aaaec1849704b3f9ce7d8f67eaaca7793b099cf4b56615ee0"
    sha256 cellar: :any, arm64_tahoe:       "8d7f71cb31f0e0546588b280f84cde52adbcf911e8403aa725bf0119bcbb7993"
    sha256 cellar: :any, arm64_sequoia:     "0c4f7d51ea1cc61510da16c51da816dc844854027d28901424ab5894ca844c28"
    sha256 cellar: :any, arm64_linux:       "2fd8e9550cb579cadc6125de944fd34865c4f95593bed765c76bf44ef3c1c3fc"
    sha256 cellar: :any, x86_64_linux:      "c9c3f0b0d59789d55f3df6e1d8eba8d668821b30062e944388028e6b241acc2d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
  def args = ["--allow-newer=base,containers,template-haskell"]

  def fetch
    rm("cabal.project.freeze")
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *args, *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{formula_opt_bin("pandoc")}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
