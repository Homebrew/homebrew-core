class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.5.3/pandoc-plot-1.5.3.tar.gz"
  sha256 "ec7646e2361ca4a6dc7a01d6f55a2817a8c77d65a0eb43ac0a04d465695ae334"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8d2ce76932d553bbc229a6f55df018dd8a0263f4f1ce8440300d7ec3ba2989"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "111bb42ec789cbe233bbc26cd405253f8f7d140f105579c5fc853fcd7dc3de8c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b49e38f3d082a86b00fac658d06a75e00ce642af2964fd9d36c4073041e30ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8e75d63455aa961271e26629effda7f5620f64fa4d63fe2b9a1d5c86e23ed9f"
    sha256 cellar: :any_skip_relocation, catalina:       "77dc7bdbafca0f80c6a2cbc90f9ba8db4ac6c36c202a7301741e1831b0185efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3010866c63275014b6147f8d61ce6f166171ed6093a6a28b41e7ae385a748369"
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
