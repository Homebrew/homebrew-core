class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.2.3/pandoc-plot-1.2.3.tar.gz"
  sha256 "e83e6cbb2dd79d23fc714729406696630aba78937493e95a758389395ff5fd64"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7adc3840d95bf27c0d4471692a03c8e22ce6775aee0c530e3fa843934c50d79c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9112b6db07fc3898fd926625bd4e18d871a5c0d7770d8a06640a91e1cb77f48"
    sha256 cellar: :any_skip_relocation, catalina:      "e5a2e773adced1b2f27710cf56963f3a75119ed757536a9490fecbb50c377880"
    sha256 cellar: :any_skip_relocation, mojave:        "ccef89ab5a6e09a6c1a5805b112d2a6afc07b5a857714de19d11a308e65c9383"
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
