class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.1a.tar.gz"
  version "0.3.17.1a"
  sha256 "eb72c2473daa28ef27f351b7424f56d44cf86e433fac2853aac3054588e3049e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "164e8d28729cda0939edbae72930963c88e6fb782020e8f2d987df40dd2404ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b3b1de7537aaf56006f927d8e6358a35d0ab22eda85f384930daf9ff2b1739f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47849d646f244b837f38e73d60c41807e4108fb2086c405c3340b2c3f05bab1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a411ba1da8571f8224de71d0e1693da39a4e60622a9d78a8bd5a4a92f4e8b087"
    sha256 cellar: :any_skip_relocation, ventura:        "19e36b5eee90e788c830e8715a2bbe3985c5e24d262bb2078005ba843976ecbd"
    sha256 cellar: :any_skip_relocation, monterey:       "576d98f3ef6c103f7dd86d9d53ab399acf8d32b851f0a7be0b0fb87587a1f1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee5f4464367b4108cb47449a50cee723ab69814e79dc295bf5fd0bbc48916804"
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
