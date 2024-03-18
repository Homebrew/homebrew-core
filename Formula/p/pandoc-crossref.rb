class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0e.tar.gz"
  version "0.3.17.0e"
  sha256 "27344f6e2c463ac4c9df6c3c5820e20daa8ae8d8351344bd91beb4aaa9e7c931"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f1288656f6cc2f4dbf895a95559db350129b69a34492a6160a36d59e57cb7f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bf97e9c733bbc500d47f8313b8ad89091824167175d5df5891103306f17f890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d481c764d6a46e6b86b7fa0b0bdab23090087eba8b00f9f7870e19c2d619bebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "11b1d4d87388c55cfa1387103cd29708b8bffd4ae54dfbfc987f1b061c2ca404"
    sha256 cellar: :any_skip_relocation, ventura:        "bd61ebc8922c7641b4550e97a81c5de5571819bac5c2e5b7093e8540c352a7f5"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5a56c3af27607fc95831a64fb4cb6c80301078110ca4957b70a983f8f96316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01212cae57038575453142fb14b952bb01053c882bb056e5fcf0ebecfc261cd9"
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
