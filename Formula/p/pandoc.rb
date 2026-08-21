class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.10.2.tar.gz"
  sha256 "ec4c5d36e355785802601986637369ada24079ac20af6c0ee85c79502d77b3f0"
  license "GPL-2.0-or-later"
  compatibility_version 6
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d1cc3844967e7de17be86186f4272e828fdf3988eda88454cd7b5d1281927e4"
    sha256 cellar: :any, arm64_sequoia: "39351d86c108d14d23271f647dc6a307d755148bc24092c3581bfc56d009c188"
    sha256 cellar: :any, arm64_sonoma:  "b55150ef693cde9704ca8b99ed2b6f70a0749524ede94b28fd8798ed1d9872bf"
    sha256 cellar: :any, sonoma:        "80243f4d67b4333ee46f14b8b4641ede4d6bd317b360418ebe7677ee8ce04c55"
    sha256 cellar: :any, arm64_linux:   "4e614977f043dbc85ca15887f0cae0a87d43943d17a10284fca0426bea98047d"
    sha256 cellar: :any, x86_64_linux:  "dfcec331aa31d35673bbee451f59202579b5ac22139e8275d0cef0c699b4c61b"
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
