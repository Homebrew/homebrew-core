class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.2.2/pandoc-plot-1.2.2.tar.gz"
  sha256 "6d8e069baeb80798fa416632d39c1713a4e11d98390e5df3d9faa3636d504452"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c619d1d51b5f6141a60316dbd94f4b2b4aae7d5a2555257efffe8333ea89708c"
    sha256 cellar: :any_skip_relocation, catalina: "64bc7de3331c119367b21f85a697b0d717c64c2336b25571d06dbfc5f683ca29"
    sha256 cellar: :any_skip_relocation, mojave:   "8187fa7b1ff7c91fecf4a25cce406d8335c19504de80831717a5fb24f6c79221"
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
