class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0c.tar.gz"
  version "0.3.17.0c"
  sha256 "9c391e87acc711b495a754623374734f38e5bd2849eacbcf03f011fd62399b64"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8372e7b2fee71520d0db2589114bd75a6763e67b0f455527a4d22d3387dff68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff1241b9695145554558131de2f25c73b1a04450ca190b5e854e17f01f2b5cdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c23c2b1940e348b4fca5bea1c0f7bf51939f96afb30dfa0527eb4c63576eb8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e6a4ee5800c7b5278bad5a09a6acf83b337593467544c64cf5b346b4a1ad1b"
    sha256 cellar: :any_skip_relocation, ventura:        "2547f312e576e71b66b38bc34b24993231c7980aa894f32bd839ac8eaef47bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "59ca577ca2da957649c3cf7321164ef066149bfe7c8fb90939298144efc0ec5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e989e106080ac8a7bcbc934c1cfba90aab140de4a3a1d1bdfdc66e981491ab29"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
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
