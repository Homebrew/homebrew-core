class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.10.tar.gz"
  sha256 "fc82815542c29802d087c25e2c1421146030806b71255ec40fc0e828fe1df877"
  license "GPL-2.0-or-later"
  compatibility_version 4
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5fb1bbd496bb7dabe3bdd89199759a17c6e6ad760d4cceb95a8b988308f19064"
    sha256 cellar: :any, arm64_sequoia: "ff92446512f37d280f6f9ee81c3a112302e39b16807d5547eeabf662e72ad859"
    sha256 cellar: :any, arm64_sonoma:  "d54dbe1affc75d52fd6d1e5f822ec08f5ec4a012dfe00f4575bb6e4bed0d337a"
    sha256 cellar: :any, sonoma:        "213602b8c8032a28e1e12cc71c99882a2d598a8dd5ba50021d15c09e9b5f4a3e"
    sha256 cellar: :any, arm64_linux:   "0d2710e2926fed8236965628cffaf6b0f361525bfb9a60441c3046a88118b75b"
    sha256 cellar: :any, x86_64_linux:  "a9eb90312967775e88be6532e36894fdfbe482e46b9e4bbccd2394981abd1bf0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
