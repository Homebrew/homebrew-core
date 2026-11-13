class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.26b.tar.gz"
  version "0.3.26b"
  sha256 "c4f3cba662ab5e66a0f3081ac88ecc03b4eda9e2319a4afda1a77fae20392b47"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "40055739827ce7268fb094e894dd6c717df224a5d7f14db76ea3ffbaa256e26c"
    sha256 cellar: :any, arm64_tahoe:       "cc2d2cc96012d76a2df53d51e0cdb06eedf205745055ba6e2b88d2f9b9cdfcb7"
    sha256 cellar: :any, arm64_sequoia:     "16d3ba470cdb85d60094be727ee974391a852fa35f37c5d1750ae1aa6b4c20e7"
    sha256 cellar: :any, arm64_linux:       "dc949778c90c942fe81fd7e04fd2ba957ab7180cada566637d00f55d056b11a6"
    sha256 cellar: :any, x86_64_linux:      "95bb6da0527fa0c6ce287c828ee21e5e60a2d020b9577b9265c01d1df6ec917d"
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
