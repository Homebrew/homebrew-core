class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "a276ba571db8912debfc53fddae7cfd686f2c10c99755d55d433721fb3c4e021"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e39ec1dc93ef23c75de467419dc8b1faf172759b79a0c2279350a642eb16cb49"
    sha256 cellar: :any,                 arm64_sequoia: "60062e41031d3d7b2decb97dbb79ae7257da92eaf472c81f6a62c450ca17b7ed"
    sha256 cellar: :any,                 arm64_sonoma:  "8a87c6906c8249dcc419e8e2f0b1bea3356acd784d826537f92e5e749a43d9fb"
    sha256 cellar: :any,                 sonoma:        "21010dd7dbb47940c40b6178651f7b2fe66297b7561bba69f69ac1a53042bc01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf8440a1cde9dc51fec542c1fba82c8ffba024c7542c5e08e419e6f0ac7ca09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048ed82e6f34720b19a95d961431b386b55f7c8d08fbdfc0604a961a2f09dc83"
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
