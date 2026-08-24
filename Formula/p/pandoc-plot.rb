class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://laurentrdc.github.io/pandoc-plot/"
  url "https://hackage.haskell.org/package/pandoc-plot-1.9.2/pandoc-plot-1.9.2.tar.gz"
  sha256 "3e94528e2fd42029054addaea25ff09ee55b78b4f1b0e610ede6f04eb859aead"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7f29f9f8ff09401b710c2de8ef158e13777021577641638b97cb6de661a31c3d"
    sha256 cellar: :any, arm64_sequoia: "30685a01e5310fe12e87d9aa304bbf9058fa9eef64bbb75b1bd5259ea688bc12"
    sha256 cellar: :any, arm64_sonoma:  "a3049b5363a4f51e07569d9163074ee585f8d00b13f2b4c564fe36ef38bb1d46"
    sha256 cellar: :any, sonoma:        "b1a384451a0819af7d1702c69282c641ccaa6367d45209d04c4302247274e4b9"
    sha256 cellar: :any, arm64_linux:   "8474e54420b8138ff73f150679454c35c1237ab8e602e5071fb09d91c7a2005b"
    sha256 cellar: :any, x86_64_linux:  "fafc48f1b8e2e89bfb22b86dd07cbc9934aefe1fa041ea8744a4008accf08325"
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
      <img src="#{filename}" />
    HTML

    assert_equal expected_html_2, output_html_2
  end
end
