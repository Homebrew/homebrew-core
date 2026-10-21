class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.26.tar.gz"
  sha256 "17c1ec465291d779e23c14bba23730d2de927c0ed35a8fd24c3ddd6e91463660"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e989f8215558ba0284d0db43770f08a5cdd47fd1e03a2e6e2285e115f4b29c70"
    sha256 cellar: :any, arm64_tahoe:       "701e3808f3cf5d15b9c9fd9f33256aa717e0a005c62580b8d7aca0d193839d4a"
    sha256 cellar: :any, arm64_sequoia:     "8e8fd27651f90ce19804eaa61936a3cd8c7fd36c1546f1b597eab5f28678f445"
    sha256 cellar: :any, arm64_linux:       "89505a7029d9fe748e90f4124adaa32cc251f298b667c68f9af0cb4330b26617"
    sha256 cellar: :any, x86_64_linux:      "527a84a45ebb29834f208df654b450e843f5820b7268654ec116a846afdc7b7e"
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
