class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.6.2/pandoc-plot-1.6.2.tar.gz"
  sha256 "ca53fb5435032b7d367014eeda957ab622ab2a4e164b38db5a98d260ab1e348b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c76b0a31754566dd4f2fd349da03d9c50f8297edf99e8671764dbbb9e52c2337"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50c3a1a61db9b15146c1ec7849b5191a827dea51f3d89e29ed12cbd4c713fb35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96fa01225eaf2f201d70d5994827c61bbb178d775d712b3580757b68740e426b"
    sha256 cellar: :any_skip_relocation, ventura:        "271c9f84ee014e864e0cfe5516113d6cabdb79efe9bbc05f01cc65a8a4908b13"
    sha256 cellar: :any_skip_relocation, monterey:       "770259f631f5974e4817cd0c43e1b2670ce56b6c3ed31ae93b02e577a90f1071"
    sha256 cellar: :any_skip_relocation, big_sur:        "90638e23b48a5e63feeef8fbfea6ff99197fd5a085a0100d5b21f04649c0ecee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d69a7a7f94ce7f0995ad9f03cb938f67419dc13094db74a38af555bac3c0180"
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
