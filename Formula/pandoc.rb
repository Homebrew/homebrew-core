class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.19/pandoc-2.19.tar.gz"
  sha256 "425c13728b4e158deb54996b6bd57bc71120af39f6d01a12b9c0ec21e8121cbf"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede8d65a434f7b294023443771640021c8b40afccd3c804b5b262b2d2b721854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d52f8dcc504ff2e565653ef023f840c419eeac85436714a85da6344d286f2e57"
    sha256 cellar: :any_skip_relocation, monterey:       "b2fb57aab492032e90d0ea1337e58198e4416bdf68be44ba229f9a49944592a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "82d59a8f0096eab082ccdabe3f0e8f86cd497e8c3486e34ac03b594a6d59ae7d"
    sha256 cellar: :any_skip_relocation, catalina:       "802806318075e80fd0040f4e1736f9b662a9ce84bacacfad59a91c2c876bd20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985ae6f79a2da8229695b7e904a1fa16aaae30e9c3ca5a9159233f14a16878c6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "man/pandoc.1"
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
