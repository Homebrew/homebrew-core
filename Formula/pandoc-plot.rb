class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.6.1/pandoc-plot-1.6.1.tar.gz"
  sha256 "2352545aaaf87dfd289a2afdcf83502000a2e6b3f3541ea94391f2c656593e0b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7ebf0aa45528c91f611db8428f0f26806c76665629a1a6d479d6c44c05d48fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a51d2060b0b2564f65f4d406cb20301037f9ca3700ef26dbf73804c0ccfc5975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee4cf67d88a2a94bcb3e2117a3f3995006fc6b7eb6fd40b488272ba912121bec"
    sha256 cellar: :any_skip_relocation, ventura:        "a6175fae0aea88a1c790ff1c7eed2b70c12cf1ad92cf52c011a4658d25d28073"
    sha256 cellar: :any_skip_relocation, monterey:       "cd557b4294b7ddff7ef2a5a7910c629a303f631e4366e8f058c3bb8bfcf434fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "55543f56eedb3ab3d2a38954799505e283e7733a2c6353b785ffd9a1e298d5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84515f55e58f8a4905293db2c6562fb0248f00d0e288c65b4f2def940f733a3f"
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
