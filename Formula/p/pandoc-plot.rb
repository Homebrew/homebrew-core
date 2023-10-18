class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.7.0/pandoc-plot-1.7.0.tar.gz"
  sha256 "065b5b6240661a36a0a5447274559a7ca9e9b75100e51e3760858fad644dc905"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e024681fff877348e509df1c22b6c17eb9a3408659bc100b53ea21f51e85de0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05e423a3062a6726bd5071458671cfc56f13bf94a64586e682cb95f71f323371"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91b61102d61edd3d1fa86839624d69f66ace3657aeaffaa1626102177991fcc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14258e2896e38667f6db42bf296c9a547dff12740397b975fbbcc8cd1fa7ea0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6748412ab90d7e2da43d6f0a8a0d4d8842d5ff166d1b5b89cfd104a38d551ed6"
    sha256 cellar: :any_skip_relocation, ventura:        "255b988924910ac16a3048c375a7732d4e8cdd09824b534232b2d604ab61cfe5"
    sha256 cellar: :any_skip_relocation, monterey:       "2f7b198c2a252971bac5d9a92412c5cc260d864862e6b13713bf4e2dfd3b83c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b733f8557cebce38a80c758a7f554be2a93e1b1eede5c21043a35cb939ad84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07f706b8a08202b84cc0b27077a306c0cb29149ec8e75504616154372a968fa"
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
