class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.9.1/pandoc-plot-1.9.1.tar.gz"
  sha256 "a34a08faf483ed7c9c5e7c439ac275077b9262bb3384d1f551e47d6aa59dd434"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "72c9bb7d9558683d428db2490b722bf71a05b2329f587a518dba7f80ed54462a"
    sha256 cellar: :any,                 arm64_sequoia: "d4bb1706c24f0ef83ad8c51b8c8494eb74a3494e37f7f0ac659142b57513070c"
    sha256 cellar: :any,                 arm64_sonoma:  "ee0283f71f83291ed5c5b533f5e228f6cc541cf8f345da1e15d8387f495c28f2"
    sha256 cellar: :any,                 arm64_ventura: "05868fd036fde7fe2b67fff77ed5a3f93781331d786558e79723235e0b0f6a56"
    sha256 cellar: :any,                 sonoma:        "61bee302ba4181e8797bdaf9e6faf4d4a06a1eb74df6f367bf7ceff7c0aed259"
    sha256 cellar: :any,                 ventura:       "9755b31b27aefc4b4a0526dda6e026bb99719b85b29bb9d7dbfcb030f62476d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7f6ff8076b1b9000b9e802a2df58f3ef78be584025281719b00ab443511b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e672908c34a06f16722e1a3dd0e7e96dd71560ba6151bfd2986a3752df03c148"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test

  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
      <figure>
      <img src="#{filename}" />
      </figure>
    HTML

    assert_equal expected_html_2, output_html_2
  end
end
