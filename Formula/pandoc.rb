class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.15/pandoc-2.15.tar.gz"
  sha256 "2e09c69a9aedaf99a50760dcb94031f802efdefd22ecefd0d3ee5444101f2e3d"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34e9012e5bf4a5334ec4c6724eb6be0a5de62a80fcf86124dc9a18d632996b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95bc299b947b70a0e7833ceb9e338b8f9ca5cfcf824b6629c32a9a7753ede15c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7251b7ae3b9222d6af04237cb65a52af788b7f3b4e69f7a55074e3661277d6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ec7c3b6b99d2acd3da1a62051d6f186c15b78cbba2d9b79723fbb29069e3a6"
    sha256 cellar: :any_skip_relocation, catalina:       "0f824c8d2f0a6cfc026e522e98d9870de59f614a3bcef6668971050eb5e91e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e1ece1bbfa73b67c6abf975a59c267f214a4a56874287bec42e27e5332c27d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
