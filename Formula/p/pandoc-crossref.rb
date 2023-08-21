class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0e.tar.gz"
  version "0.3.16.0e"
  sha256 "7a3101189660358fa5738717464fd49da3197ccb1417ef9f2d90e50fab75e3c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fc39f68c3724c9a6bdaa1145557663fc5eb1585f221479b6fb093a94e7043a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee23d99918b0c4b6bb87cd230b30dae730a896904dcbe7a23ef5579922eab128"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbdc0af4c38beeb62537c152de689d15ca339ff2b1b9d6dde342c3dcf01e45aa"
    sha256 cellar: :any_skip_relocation, ventura:        "6994dcb56f6cf92749b625a858703f18add196e8fd805475426611b0c0f7687a"
    sha256 cellar: :any_skip_relocation, monterey:       "1e45df1631ea63052999ce8e9caf44a4b0eafff19a7d32f6601222eafe162b4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b58fe67aebb48ed29e75e4c6b89d46d2dbaade5aa2ad1c827c43d71d7217af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf4d6e3275da2a319d02c053ecd27a7bd90272b08f84e2ca33cfcc258c78aaa"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
