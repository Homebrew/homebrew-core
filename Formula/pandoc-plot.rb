class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.5.3/pandoc-plot-1.5.3.tar.gz"
  sha256 "ec7646e2361ca4a6dc7a01d6f55a2817a8c77d65a0eb43ac0a04d465695ae334"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5541f53a5a73da9df5171bdd4b58a80a1f4954a83e135944df5288a25c509ea3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9fba4be2f673b01398c5322fa6b8ebc5ced0f61fd488dffb50d178a1fb24f19"
    sha256 cellar: :any_skip_relocation, monterey:       "66bf1cac5699f844443aec4c2e3180adc133d4a5c55bc00f5d4a6fe768df6caa"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc2cb317d9910c32900498ebfe347a690ae6956c3d18bdace636609bb1c27319"
    sha256 cellar: :any_skip_relocation, catalina:       "95d7df2374a890dfe72668b5474dfc9970df141bae68e69782644406cf611d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e13940b38d9e0abcd1574e5d354b92454e72e42eef8be174c30af6a7182cf05"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    input_markdown_1 = <<~EOS
      # pandoc-plot demo

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    input_markdown_2 = <<~EOS
      # repeat the same thing

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    output_html_1 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_1)
    output_html_2 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_2)
    filename = output_html_1.match(%r{(plots/[\da-z]+\.png)}i)

    expected_html_2 = <<~EOS
      <h1 id="repeat-the-same-thing">repeat the same thing</h1>
      <p><img src="#{filename}" /></p>
    EOS

    assert_equal expected_html_2, output_html_2
  end
end
