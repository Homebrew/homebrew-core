class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.13.tar.gz"
  sha256 "e00265e5aa56ecb214d12fd7781e87d77abf101dd8d02e15c4d648ad50a5ef80"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5175052253fcaa29adf1e1ed6346f0aac2c774f7a0e6920f88df4d6585f0435d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed2d314e5adaea5ebc6cfb55559bb47660f36f34ae3904c7b1f8e3b5962b1103"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d3f006a8ea6cce61725421edf05039732357cb7de17c37e6fe342f7e0d5325"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f506112393f6f3c6633c3192aae4e75bad13cd43d8e335fb0d5eb3f0577c70c"
    sha256 cellar: :any_skip_relocation, ventura:        "87f8b95cb03053d8475cbbd0e37f74697f3d75d2cade34b6f9489a11804f46b7"
    sha256 cellar: :any_skip_relocation, monterey:       "18b0d37954b41416dedcc3e8e4dbae1d97048bd674c4415ebf00eb3f6659bba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3038a3827779e225db2076b9674112a5e910c372f0486f81d7fed010167ec4e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
