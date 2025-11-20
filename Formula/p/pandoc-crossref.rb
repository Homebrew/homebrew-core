class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22a.tar.gz"
  version "0.3.22a"
  sha256 "6957b4bdd121200ed61c2a3b466f192e4afce547677c4c7a5fdee3925d3daab0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11535bcc07f67f87326e56e6297a5466a293d938a04ed8fdfee04bb80dc81f4e"
    sha256 cellar: :any,                 arm64_sequoia: "eeb1d6938ea191bf8c04b943452ce1e22b1f16a30664192b0c14123ed6e752db"
    sha256 cellar: :any,                 arm64_sonoma:  "dba3689a4a9b89fbc463f832c4e27ef6e7b5458dd52594a6d2e9e88aa85ca00c"
    sha256 cellar: :any,                 sonoma:        "13f4ab0774b2a1303e3a291d2bee0fc127da64ee3abd92d08c4b0f8aee24626b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4e457f88957411e313dd22bc9f0463dc56fa41319e19d483398bab8c76cb51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ebb2f98aa98cf57cae61abe327f2061ad5a3f2fc926b08f0fa6e2d7d714b9b"
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
