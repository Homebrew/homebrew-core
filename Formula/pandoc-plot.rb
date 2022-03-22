class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.5.0/pandoc-plot-1.5.0.tar.gz"
  sha256 "7e97f18cd95f9cce73160da433a1c84dbadaf44906dcf99fb11dbefedd3458d9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8ef34f12753a7458cdf7b7662b192a10a47fa0c606309b0e485453ef4ae1bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f2a06b53340623568cd294d733ab1c7addcb8333f4d8ab9b1383cede970a9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "0f85fd725a38fea05407d3e593d1b5c50090b10b12788c518419cd9ed08cdaa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "af67c7e047ce90795402fa504800d48b661094e121998f424cba4958e829fb9f"
    sha256 cellar: :any_skip_relocation, catalina:       "af1c95ae7f66be8bef6f92c6db9d3bc5af6152bb9828d4adca9d1c2da3eb9420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f46700caa0a81207ff4e21faf4614569aaa613d4e2f0c159cf1c7dea5665321c"
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
