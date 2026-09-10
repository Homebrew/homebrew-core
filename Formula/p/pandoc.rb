class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.11.tar.gz"
  sha256 "61d05e7fc57e995a61367bee1bb73a8bb278cda3c787b7e4e27b30037e17aeed"
  license "GPL-2.0-or-later"
  compatibility_version 7
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c328263f5013eb0997bb47d20727815b81ae148342bc3d5b2f3d2227e5e9368c"
    sha256 cellar: :any, arm64_sequoia: "53cc1586ad45f320bdb5d06fe7ca8ff0be311172bc89d5baa962d1f93fa3c831"
    sha256 cellar: :any, arm64_sonoma:  "b35b39abe5e11982a592a4ee9ab33484935f82dd7fce9cf76aecb1de824b0dc1"
    sha256 cellar: :any, arm64_linux:   "55da2d1713dedae60220591caf79ddcda51c94ca198aae25d1b75884a69ba73f"
    sha256 cellar: :any, x86_64_linux:  "0b9c3302f1d2b40e671b68e85c0093d0460b17c148e2ea54f4f379950983a566"
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
