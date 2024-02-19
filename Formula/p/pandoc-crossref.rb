class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0c.tar.gz"
  version "0.3.17.0c"
  sha256 "9c391e87acc711b495a754623374734f38e5bd2849eacbcf03f011fd62399b64"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ee6a65ce4fa214d8015ed938211a68b485cc18b070568463bf620f84f7b153a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c551fd0696f32f5a3350cfc51e4ef31331058405f6abe02b8fba2494aac7fa65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6238117c8327b0035a2e93e35c930b0c33e0006f6f5f2a9b7cf67faf6522b2d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c21a4305fc7cecb785ee4922abc20b96c03415404c35ec0c3bce56fdf2d5a98f"
    sha256 cellar: :any_skip_relocation, ventura:        "668befa2ddb2d0bc90e8af3d313c141fff60f734714a656d2fd4e68034c320f7"
    sha256 cellar: :any_skip_relocation, monterey:       "c16d8da8471bd96999ba5a8b81c1431e8a856235f9d11bdaa4cca6226fb27e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3308b4ff8ffb97bf1a62b783e879f248414d590ac66a4dc04fdb493bb05c374b"
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
