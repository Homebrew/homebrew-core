class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.4.1/pandoc-plot-1.4.1.tar.gz"
  sha256 "f06987337e2b5fa59e214d835fae851e2d57ee6236097aac74408322e72927bd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681f47321d38a8f30db77d90dc3e5731d38caaa23e4770ca21ffcfa12970f37a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5b3c938ec9f2c7e72a55dc6e6bad24260caaaf3930c6b7c9572213c7a93c163"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b1ac55714413d48f6b0f88bb277365ce27de1277212845ea588bb8ae4fe6ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "51b0c54ad26b1986f889fdee966d6c123be1425836c8fcc6a1649dba38d62f5b"
    sha256 cellar: :any_skip_relocation, catalina:       "52c5ee80e51085eff721fc4ba243450208900d5615fc280891987f9a44ec88c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c2c41cf4ee2ea6f9684c9c1d9c3c6d84623c4cc52791209fd1db39aba37128"
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
