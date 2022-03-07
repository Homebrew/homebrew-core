class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.4.1/pandoc-plot-1.4.1.tar.gz"
  sha256 "f06987337e2b5fa59e214d835fae851e2d57ee6236097aac74408322e72927bd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4592441d6f31bc4f608e2e0f97dd7cb02624a4fe3628962020f81497849e3d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b701b552d104938b5a018a0e09b1d9b872d9ae21a0028bd667016ace7796cf2c"
    sha256 cellar: :any_skip_relocation, monterey:       "ffcd38e6724cc72cf02bdd4458e98f1d4b9911782e0693c9bfc9f37c410c9f10"
    sha256 cellar: :any_skip_relocation, big_sur:        "be3308a0a2a5f2b16704eb9cfb94a21fb7c6f85a932053799060d06b8fdad681"
    sha256 cellar: :any_skip_relocation, catalina:       "a60a242ed0a22a266264de7b7ec15314241e6662f1cccdd10bab5ed3fe83bc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1661431d9f03a26c185b3358424e26b465b95a14670a279b29cc0f01cba70199"
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
