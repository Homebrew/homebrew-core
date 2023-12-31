class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0b.tar.gz"
  version "0.3.17.0b"
  sha256 "6663e5fed9d3b18f7877e5dd98514520a55cfc3776e838be9daaaa16f7c04275"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f9750dcdfa6186f4930d7581716bd78569013dd2e0255efb133bfd6b8bad3ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a04279acd601bf72602b3a49fceddbdb8d9d2db047f26da8623fc3c56d3cf1b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61a9593c414f7062975874a4113c01c15363bfa9dc639f823575fd4d7e153a46"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a9312f948dca70c08a5abe47babb0aecbe312a425b911fed90b8a2c48bf6cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "9bcfeade999213f0f088172902625c6db10425128b55c4bd6a8cfc117edaa1f4"
    sha256 cellar: :any_skip_relocation, monterey:       "777ac660dfc37e01780ae1fd43c179f83e03252e587fc7fd6fd80d27b4da1c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44c8fd122ed157323d53fa34ff34e96669771a001a7ff5c0eea239016d5e479"
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
