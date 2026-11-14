class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.14.tar.gz"
  sha256 "e4c4292642531b94793c2f5dea38f3b8d5424b2d048818a4d047f8b8320b999a"
  license "GPL-2.0-or-later"
  compatibility_version 10
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db3c668261bdc18566b44f2dcb89a172a0b1e5485b5c72fcf343d2f7d7c2ac8e"
    sha256 cellar: :any, arm64_tahoe:       "6fc0e13edce13abfa4dce87b16793d9fe2e859396c4f59c0f4010cfbc0cec77c"
    sha256 cellar: :any, arm64_sequoia:     "f08452641481cdb0a29e8c5b2029395b32756185153f691094bc857e8f1cbc35"
    sha256 cellar: :any, arm64_linux:       "c3af17977edaecc7c4ae84a008a6bdd3ff21639ecf7b37127be0408f4dd41545"
    sha256 cellar: :any, x86_64_linux:      "20cf5c008062fb2d3e6fbe9c751d668f04ee3d86d9baefd80b9846f835076d0c"
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
