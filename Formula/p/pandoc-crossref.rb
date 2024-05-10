class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.1.tar.gz"
  sha256 "b6183dd15954100f6f7acbf49ea5f845f9c5f851f895eb4e805002b3cafdd875"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bbcdf1d6c60d0555ced827080bdc755d12becc7fc7c09a5b6013d6c151b6e8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f8e38a86f7cad9503e4b42ee1ceb47b99aabf0f4f1ced9b80cd34c2091d36b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72a0904246b2e34d4aaa96181c3d55caf083c529361eeacf29b8a541bbb1e283"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6e5824ef29864e7f98e54b9736b30cfec0d09b403620e343887850cda69e3b3"
    sha256 cellar: :any_skip_relocation, ventura:        "39d67ac7b586b1b0663fd90076d497a2f40b13425db5c70bd3cf6871af891077"
    sha256 cellar: :any_skip_relocation, monterey:       "f4573756b74bcaa295c2ff97c507ef01e7ee140e4dc376e5f879687ba3073e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a122fb2bc4ecff7e09f35bf35ef923ef599be933feb806a88d00189c49f2f6"
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
