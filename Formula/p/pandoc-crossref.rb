class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0f.tar.gz"
  version "0.3.17.0f"
  sha256 "2301802824666435c50c0a00032a9ca9842c189ea62eb69c3c43ac4da4d4762a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28b2a208e299cb7b6dc5b5d7b858adb738c4e99e8025ee1b8458da0a24521c0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d841193671012273b2fb3c704c3e444dcb50003358311f58b197604b0cc31f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b992810992874db8d4b6103949d2909cf6144c4fa3f2e1b4c4594864ec8a98f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a65a8ab9d3a341b3e4d90fcc4e9f69d061b603800dd9f8895d3a6364c4d4274"
    sha256 cellar: :any_skip_relocation, ventura:        "562890f789f96e8841458d9136b03ab3bc4639346a17aff549ba26d180b71e48"
    sha256 cellar: :any_skip_relocation, monterey:       "13c2e5fb81232ab9bc13131d64e6bce3d25633d225787e35aec5027745ed2161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b509684a879c432e9098810d35e3cf7429404e9c53a48c7bc46bf61426284e"
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
