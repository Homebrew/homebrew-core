class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.5.4/pandoc-plot-1.5.4.tar.gz"
  sha256 "481969a763903c19787054b85da10f814e96671f0880f90ecd0e62ac0afdb6ae"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6de4c6432a454f63e7d9eab0cbee1d1bbf21f02285f440c0c0065676e94607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47215bd3b0adc7a5e563d39166129ddf854d1c10fd1c34d91577d7b9d73d3fc9"
    sha256 cellar: :any_skip_relocation, monterey:       "31bbbb42a89b7f4965bcfa0bd83f9b51b8ea86a023c2a2c80cb680587ead0ebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b07d5070b5425f0f08c45d3aaab5e805c859e82bc84fa70215fea13ffffe121"
    sha256 cellar: :any_skip_relocation, catalina:       "d93868b01fb949ab8074e988a300d7d1a5ac2853e78477ed90a9e4407b6d8205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d8bfdae956f8ba9c5a042f60449eaff0c263bcafd43e44af3fdcfaf7b7453c"
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
