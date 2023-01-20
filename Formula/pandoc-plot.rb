class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.6.0/pandoc-plot-1.6.0.tar.gz"
  sha256 "a685fb4618b1d0d3ae84921bbb97cffff20c62c15fae9e8c2b9c039a9585ad93"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e9f11f10fc2c7119e4df43e681eb5ef07154f405ca5d97d39b87b88afb3dd4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba31f72c88a32380b31d31e0f2fc8fbffd5596c06ae02e23eff0c09ee4e08d72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aeae2a6127242160d8bf858b4a4356d542b7b2f5d1a56e22b5e1a32f82c2115"
    sha256 cellar: :any_skip_relocation, ventura:        "32dc6c3fa4bdf9c92b385288163fb27fb596d3bb096759a7ee0d875af9023d12"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8d2bad7d579179cb76c1f08372fdbb941f3594a6e4f26060705ef9d5f3ed46"
    sha256 cellar: :any_skip_relocation, big_sur:        "f945ced817ed3eacdcada2613de7807d5eb1a6a21d19c69b41d75e5817f672aa"
    sha256 cellar: :any_skip_relocation, catalina:       "d96f2c26d6aae4af843f9b0dbc4078f4cfff5f1582d94a6ec293fe8a5f84bac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb21b050c3c19a77d5caf780207cf9a3123e398dcfea1a11408f9762c188adc6"
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
      <figure>
      <img src="#{filename}" />
      </figure>
    EOS

    assert_equal expected_html_2, output_html_2
  end
end
