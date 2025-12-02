class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22a.tar.gz"
  version "0.3.22a"
  sha256 "6957b4bdd121200ed61c2a3b466f192e4afce547677c4c7a5fdee3925d3daab0"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ec4356aed58d6f946c9b19e275dcf5cc4cc85f06f5c65caa63abe578f25a135"
    sha256 cellar: :any,                 arm64_sequoia: "093fd2970faee3660f1bac3bd1593943b6352cede04f2acd9c6d4245e30acc3d"
    sha256 cellar: :any,                 arm64_sonoma:  "51a3b5c1980d8a75a618e74253f9e36dc213dbf5c942ea0e4e2a7befd2836704"
    sha256 cellar: :any,                 sonoma:        "04504771f3fa18384d05316ce2d73773ab4f9a6366fcd93d8cf27da32257fb92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bffc67f6f0efc797e3819c17a6a58c2196583d494e0adf715dfa253530d0378a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422b8ac382590be1c330d02fcb0352793b33ac007cf0b28fb2a9a4c3987b44d9"
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
