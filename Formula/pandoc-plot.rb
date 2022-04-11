class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.5.1/pandoc-plot-1.5.1.tar.gz"
  sha256 "216d7d0c5db2716ac2be076cf8b405f5da451900645c97721a98c841d8571358"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c154bfae27f884c857c509966a89745d9dc370ad25bc233c4f09486661f40ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f0eeed755f85289826ad0830b38baa0972776d4b260a7cc8c5e37ab2a6783a"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd2509415802e0fcb3f6307a7986e57117b1fb88a41d03b52eb4f20ca793b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "95c496284aaa92f6d0121fb2f767a11386b146b7dc85ad6a94a78cfc0106cd11"
    sha256 cellar: :any_skip_relocation, catalina:       "38c2d85123870ccc43ffebb913bfe23d998307e1e4a034db5273af167522ef1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1fb7c505a9ab2968ed9638e97be3a4aeba28d016281a79a3b27808ac7b05b1d"
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
