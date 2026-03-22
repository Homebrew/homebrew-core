class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.9.1/pandoc-plot-1.9.1.tar.gz"
  sha256 "a34a08faf483ed7c9c5e7c439ac275077b9262bb3384d1f551e47d6aa59dd434"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "2f4b7184bb86193122734de1913d2d31056b99c8c7fa981397b3f276f62ee9aa"
    sha256 cellar: :any,                 arm64_sequoia: "32b7df218917c6d8052e2729c493ad901d7a0a255ebf15290ddba6a65a16189b"
    sha256 cellar: :any,                 arm64_sonoma:  "98fe64430c6d6d3074dfc8968905cd7aa61fc58adb039bcbaf25328d0590d384"
    sha256 cellar: :any,                 sonoma:        "3ab7fd029b2f04f9f5ac7c37f659b3134cc589b7ff018e637889a869a7ea0b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "824d73e31ddaa745a587e66165f12aed3505a896b93db23837dd5aab07965260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25be6dd6c818cae1074655c956e2d1643d4a143025c3a61fbb01e0c787763cb0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test

  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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
