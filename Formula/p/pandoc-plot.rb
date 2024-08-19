class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.8.0/pandoc-plot-1.8.0.tar.gz"
  sha256 "bdcb2c424e4f031ef8520943e5b61679cae01f51ca35887c28fd92eb17f8e241"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61f9c2fc41122b2a2253b5725a5c14cbcfa55a5ae152907c38efc1542d7d3ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e578a6cc80a3a404b105f54e33e9fc288d179af4812a39e3361067b774a823cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f5c003812b407609d816b0b220b638b71a15fb63daab763006fe37a38d1efcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "34d076508cdaa73d033699df89b2d4404e688eafe7f555a034296af85ba05c40"
    sha256 cellar: :any_skip_relocation, ventura:        "0647ceb0880cae41840143dc4f176dffd6ddecf59077311fd5b492793a8fa0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ccc2183be46b10b56fe79a62c54ec3947e7c2092db6be08dc3077e8d9b7d3a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494066c10c56cea658b48546412e5da45ac6033b97a9c2062218d9704ce76c5b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test

  depends_on "pandoc"

  uses_from_macos "zlib"

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
