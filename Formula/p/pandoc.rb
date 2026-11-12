class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.14.tar.gz"
  sha256 "e4c4292642531b94793c2f5dea38f3b8d5424b2d048818a4d047f8b8320b999a"
  license "GPL-2.0-or-later"
  compatibility_version 10
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4c42d151fdb351ebe1bcc26dad05f7235b8cbf383ed07f82ca34603b75bb2022"
    sha256 cellar: :any, arm64_tahoe:       "5c21c92a5357bedc2696c04244d1e6dde5c8de24c0c984225eb946c48d1c6b24"
    sha256 cellar: :any, arm64_sequoia:     "edf323d702a29b36d6fc516a9515c2155c5da517e86adf1b8000557a006906ad"
    sha256 cellar: :any, arm64_linux:       "a6dfedcd58de28ec8ed3c826a1a532ae30f9d4a57118c7237e3417ea2e7a4581"
    sha256 cellar: :any, x86_64_linux:      "4034ffa4fbce68e7b18deb885b5f68e313d4420a85d3ec07ccac37ed94ad1b43"
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
    args = ["--allow-newer=base,containers,template-haskell", "--constraint=pandoc +http"]

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
