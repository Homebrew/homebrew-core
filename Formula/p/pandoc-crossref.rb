class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "935d66e4b52323aba625b2bfa90abfea774816ccf4feb959e8271beac6d9b453"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d51e468d495edd3e4c095a3622e9061cdac17c821f6dd7413c1d164b417ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e46fc078835657efdb599697aa350ec00162cd31e41f2b8b92d8e20e94744a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fe60c0d48d2caafbb8b671fbed7d2434a0097bbb32f01953e3b46c35a82fa40"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc0f3c9b025b95fa2eef1ca33b7e12a484326aba0f277f7496c2b74035dec7f"
    sha256 cellar: :any_skip_relocation, ventura:       "936561b8adb00d74f6fc95f8ee7178b6a02897215585b4f03382fb5bce456e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f352c2f63a4b94c7bfdf4357b021996e76dbe48e5a5172ac071bd14dc9cedb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b1a3ea50bced573f3fab7df9e5f21e0f86d511f21a98f69ad5ed87745b6295"
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
