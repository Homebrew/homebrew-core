class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22b.tar.gz"
  version "0.3.22b"
  sha256 "f7ce5f637ca27169286ebc66c684a60bee379e0545ba7b5d75b439cf65a84a5e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "528b3f91d2ea0a7d05ab1cd32081f7c7659807dd7e4327ec10a783d4e98e2271"
    sha256 cellar: :any,                 arm64_sequoia: "630a5c00e8f2723e560a44942ad4ab8f186a395ba75c67b034324b0efef80f97"
    sha256 cellar: :any,                 arm64_sonoma:  "352065d71cf5ea6dc06da75e8f2a913d86356c3671b4d8fb39fe363e178fbc7b"
    sha256 cellar: :any,                 sonoma:        "7cb8dbeea448be750cd49848a2be7c4b0439f786431dc4ff0fb73f761d4c1276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c2ee6a13e4f1945d558caf145ead90d950ad3252cc9878ed52f6d2fb667950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63595278b847e03fd84635d14b6faf9df7d4ac9bbc9c3ef349a6796e71b0ed60"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

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
