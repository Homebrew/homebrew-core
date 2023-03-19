class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.15.2.tar.gz"
  sha256 "f91e69cd0c69923353ea4c3d408ccb245b7acf47153f95a670e5a3bc4bb7ea8d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2f7eb02cc6feb8d80fcb450fbb4edde8f572b9c7e3f29dbbb67c92a678159fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e529c249817614cd61356ec16c5d8b44f5314619f974a9124ed67429f7b9960"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec0198c0a85d0c121112781d6821b5173c2a569eaf9f7fa8da384533b2b91ed6"
    sha256 cellar: :any_skip_relocation, ventura:        "8768cde6d0151662c6af96f534e1b42d9a3b526c3e616d348e9b890f845681e4"
    sha256 cellar: :any_skip_relocation, monterey:       "53284d4df329e8823bcc1b5610d84a65e38c630e8766a8479be71367dba78245"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e77ad11a929aaf2b22053f1048f21a0d65f3c55dccea559a46108c3886c1349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d17e4ba400c8dd18a7641521dd7b02de98b7388963db122b11d64c98237476"
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
