class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.21.tar.gz"
  sha256 "48f21b868901ccb23654079fc2929500658d3a76252d3d9b86ee11d4c180815b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027bbf82de25395da72b288506c4c989143aab4ae4f5b782d1d58629eec3ee52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee485648dc70db43cbc8e63e3165f085060037fd80a75006a575df843e91117"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c178d9540b2e21e777bab90aa6a9970acf26eca906e53e09806396f15add2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "df89506df832bf4240d0f563f28ec2fbb5eaa77da1d2e41e610f779f07b8bd67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a582aab615d05bf844dd5462ed8d8b945c5742c75d41eb19489960316409ac6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a53e52b087683fe6a5428b945603d23ff1d5370964822e2fa63e6ceeb1d67f"
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
