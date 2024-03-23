class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0f.tar.gz"
  version "0.3.17.0f"
  sha256 "2301802824666435c50c0a00032a9ca9842c189ea62eb69c3c43ac4da4d4762a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04516489216ed22923ad1b4bb7c7532cd11cf116402b17cd890b8287e0a6ac14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64e3a543705b5e1b5cab8acd69e8c306d702ce2aad59491fd8faa2bbe211398d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49e731fa6278f8abaabe8956b876bae09d0e13371be8d05a68b439a0882a2906"
    sha256 cellar: :any_skip_relocation, sonoma:         "325a640b2db90d48a50ec6b9bba87949bfba4ec35d4961d28d72fe399732e0eb"
    sha256 cellar: :any_skip_relocation, ventura:        "523b3f8b631b6cb939ee2af7c0b1d4598b14686522a4d1ffc11e9a7a80599eaf"
    sha256 cellar: :any_skip_relocation, monterey:       "1520602ad949cec9f922f4f61a922b8a1f65820b5c745b74f21b0722444fb68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df39eeead5ff678db8e3714cd3977f92c73b826ad9139f9d3a222e4d33540dbe"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm_f "cabal.project.freeze"

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
