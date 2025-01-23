class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.18.1a.tar.gz"
  version "0.3.18.1a"
  sha256 "92c09c09d2008279884e3549fcb536fa578a51d7ca9a20a8c9a1792449a80ad8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bfd528706f039afe5bc7f6b1d0f3ab69f6f50530302f7edae4c315f906d2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb5dbfad327f5e4cb5471f3aa7b0277fd8abaa11bbcc19a49c7306439fdb1efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5e8e97dda397c4f3b42e22ab6b32cd69da8a6154395676be2ff000bcd6e43eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a922bda3187afd959348eff576f7b7f16b5e78053beb788c2e2380ef15b1d21b"
    sha256 cellar: :any_skip_relocation, ventura:       "3cca5d45fc7e4eb6827fdfbdbd2b813ed1e55d3aa27340db1d9e1b54c62f71c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "106f0af665ca9b9abcda54d77fc4786065f9ac6af73762253f475ab5cdbad46e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
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
