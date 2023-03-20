class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.15.2.tar.gz"
  sha256 "f91e69cd0c69923353ea4c3d408ccb245b7acf47153f95a670e5a3bc4bb7ea8d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2c98c25ab0db1bee2e565afba2f93d147a8a898fc87a3b7ace18119f941465"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786b6a1453e315a1cf2e404d3b92da999ed6e03ab224cec996a30e681c906a65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "268429e3aaba8a06975c5912f0349c88d044b7448b4bbc7dcc1b0c969d8ffddf"
    sha256 cellar: :any_skip_relocation, ventura:        "2baecf196f1d2e66af5b4786e433cd28475ed200d8ce7a24efab9922c40ffc6b"
    sha256 cellar: :any_skip_relocation, monterey:       "12ad68245c994e340841e65656fdb43f6feb055feb3686e9cfa2cc5282fb4ce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9df54cf1477d5eaeb2a363ad56137484368cbc82c5becf9c4dcfc8c23bb9989e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50bea6c997674d2e1fc0f7921d9cf88e3f2ad106c3d5ac641c87e49475bc001f"
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
