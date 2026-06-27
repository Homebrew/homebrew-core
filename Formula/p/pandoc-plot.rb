class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://laurentrdc.github.io/pandoc-plot/"
  url "https://hackage.haskell.org/package/pandoc-plot-1.9.2/pandoc-plot-1.9.2.tar.gz"
  sha256 "3e94528e2fd42029054addaea25ff09ee55b78b4f1b0e610ede6f04eb859aead"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7030ed9717d27fbc70f5f6b0ea2d70cd9257d91d020ed48c873ab9aa0b4ee992"
    sha256 cellar: :any,                 arm64_sequoia: "59d6ace221c7ca5aace5187d2de39ba5dff4c6e329414f31406d1ab858d21312"
    sha256 cellar: :any,                 arm64_sonoma:  "980b454a45c2d3dd7527438b99a2a08ccc2e63a61bff7f986ba6cf7e5267b80f"
    sha256 cellar: :any,                 sonoma:        "2498cc1e06649ca7e5934d2faffeb7e9c16b635c38bf375d8a0e1f57526fff96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d42ecbaad3d2df45516168c22262cd6d23366d46a4ae58a1f7897402d3bf8218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "578d2478f5800019376105b33637d913a7f01d4dc721cd66893b775ac45670f3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test

  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    input_markdown_1 = <<~MARKDOWN
      # pandoc-plot demo

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    MARKDOWN

    input_markdown_2 = <<~MARKDOWN
      # repeat the same thing

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    MARKDOWN

    output_html_1 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_1)
    output_html_2 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_2)
    filename = output_html_1.match(%r{(plots/[\da-z]+\.png)}i)

    expected_html_2 = <<~HTML
      <h1 id="repeat-the-same-thing">repeat the same thing</h1>
      <img src="#{filename}" />
    HTML

    assert_equal expected_html_2, output_html_2
  end
end
