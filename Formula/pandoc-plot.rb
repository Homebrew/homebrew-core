class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.1.1/pandoc-plot-1.1.1.tar.gz"
  sha256 "00b67fda0d7faa2da6a149d4e69d1f547036ba5dd55f4bbbacf0ce714f649c83"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "916e4cb6d7a0ebbacc030cb93d831ec9284bfe3c266bb97b7a292fa8c23eef7d"
    sha256 cellar: :any_skip_relocation, catalina: "8cbfc7637c688db43a4ee9a879ed8b37360b7069e8ab72441a42b60a9f1d992e"
    sha256 cellar: :any_skip_relocation, mojave:   "faafca14fbfeed888d05ae4a715b1b57c386511ee9f9006e405a3a58cf50e5a3"
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
    input_markdown = <<~EOS
      # pandoc-plot demo

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS
    expected_html = <<~EOS
      <h1 id="pandoc-plot-demo">pandoc-plot demo</h1>
      <figure>
      <img src="plots/15141642126418287350.png" />
      </figure>
    EOS
    assert_equal expected_html, pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown)
  end
end
