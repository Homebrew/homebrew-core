class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.1c.tar.gz"
  version "0.3.17.1c"
  sha256 "1c1d00d356c74749d530b508db2e6aca6fe9f5ae3a283af58d25bedc99293977"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c94edf93c9f715b57577df9412dcdba0051b921304ff1885d880ddf7f049ec8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971e09c4acbb7f0331738d28b7f23ef905e444aa1ce7bcd2001dd84b8d5565b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f58513da6d5c759db7726f2a58de805bb58b23e8797bd882d159066e0795dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dc0f52abfeeb9fa1d1d12d1833fdecaf20049dca2ebe7057a4d7256a39ed604"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e1cff8bf41b03362223374fb0a5880bccf6811dadeffab0a3b17cce6715ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "d7015c5a49f787bef8ba735b31e206875d56591215c3d5317e5f9b380aa8128d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638d0887665fededa6bd785f025cf6e3ca12691be15b0451d7fa45b7f7ea4820"
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
