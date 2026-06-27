class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.24a.tar.gz"
  version "0.3.24a"
  sha256 "5b478c94b67d5b972c7b3d867a345be982d3af12475e2261dd9b37fc17e225d1"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50baeef7744c5014537ac4ce4d4ba833c2ebd453556ab68adabf731635a460ed"
    sha256 cellar: :any, arm64_sequoia: "04da0b671513977bb99e916a9f01c760279a680e72b107b72c164899d52490c8"
    sha256 cellar: :any, arm64_sonoma:  "62c04f3e1e89495a54cc6e7754ab2c7048b853780427fd294f079c1c6d658b92"
    sha256 cellar: :any, sonoma:        "e84ee17b51a89680b70ffce5ea9c6e7e1b409e3cb9c82e83059fc250c403b518"
    sha256 cellar: :any, arm64_linux:   "991863f6fb6897cbd9f7e522bb0ff85a2d28c38a55681619a803ebd23bde469d"
    sha256 cellar: :any, x86_64_linux:  "b89082227fea2a883b17c35458a1fa38b68c3fbf2cf0668f0f51af58a19203c8"
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

  # Workaround for pandoc 3.10.
  # PR ref: https://github.com/lierdakil/pandoc-crossref/pull/510
  patch do
    url "https://github.com/lierdakil/pandoc-crossref/commit/d786c849c54841c809f2f13bda841c038a865e03.patch?full_index=1"
    sha256 "df60d96e2e20f7d7d13582ebdbf690daff2cb1a05f130311cf6ef92459ca1691"
  end

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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
