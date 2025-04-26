class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.9.1/pandoc-plot-1.9.1.tar.gz"
  sha256 "a34a08faf483ed7c9c5e7c439ac275077b9262bb3384d1f551e47d6aa59dd434"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277fe6f242119166f8d77f2b07b109129425ed673547fbaaa2d6f01e68c5d7c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4647b4e4e30b594f08bd6c871dac82b26d7bb1fbe75d850a77d8c445a1b8774a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a576bb85965c0aaab47ea0d10b1ce99310ce7ea453361e28f90fd6142644da7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb0f022f0722c571818a6d9a4786e6aa92ed6a7ce0af8e47ce43bae83dd0c193"
    sha256 cellar: :any_skip_relocation, ventura:       "624f4ee454a269b92a633a306632b99e0365e952b0bd2de17e40bfec21443fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8054d18e5ca238e9dc229083d65ea5aba64262cac3f175fd412038dd70981b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177f0c90f6cb82159908834ad1ad93a3b60d4df9e282036862a9b9634f29bb2f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "graphviz" => :test

  depends_on "pandoc"

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
