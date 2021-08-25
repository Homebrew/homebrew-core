class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.3.0/pandoc-plot-1.3.0.tar.gz"
  sha256 "d1abc849c0e8b886c1cf237299572ba6182df82bf860140ee44d3f0ff8626334"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0d1edcddf70d0803741a42ad112299fe901bf0f73f4e746ebd831af0eb9a8cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "120bd15c035dbf94e35c5c2fdbc27e551f72bfecf6d92b77ece3c525a7f4f863"
    sha256 cellar: :any_skip_relocation, catalina:      "7761b38c9970d18e837f898dd3cd24ca1030438a8a4ba6d2c9c08c91287978bf"
    sha256 cellar: :any_skip_relocation, mojave:        "7eb7ee123b453b2d33be167b838914ae12fcb9c13f4382d1cdf1f3350ecd9722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9763df9be2d2d16bc6c5d7acd26de8528fe8eb1cc42c8f950d7c274fa866e8"
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
