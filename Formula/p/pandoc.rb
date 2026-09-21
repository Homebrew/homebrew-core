class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.11.tar.gz"
  sha256 "61d05e7fc57e995a61367bee1bb73a8bb278cda3c787b7e4e27b30037e17aeed"
  license "GPL-2.0-or-later"
  compatibility_version 7
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "20c52fd64aa4b548acc1caced548e964a3d3190236901c7c9d6012657900d58b"
    sha256 cellar: :any, arm64_tahoe:       "26978ae1ec954c9ff6c7b60af84db3800e9bf783a4ce23954d26293100bd88a6"
    sha256 cellar: :any, arm64_sequoia:     "674dd89435c289dd72fd87b33245bd99d4795adf2496d703944d6dc88438072e"
    sha256 cellar: :any, arm64_linux:       "9d839a9cc045da5a199b5756f53a2a7a608442f16fdf35f17d90eb4272a98783"
    sha256 cellar: :any, x86_64_linux:      "2d012922fb4f9ab04a6bdc7dd4a0516b7c8cc97bdf192ef0fdc860b237605d9a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :build

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
  end

  test do
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown, 0)
  end
end
