class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.17.0.1/pandoc-2.17.0.1.tar.gz"
  sha256 "276467f08335d495340d2ec439a1734101068f690c8b53f16c3d736e39df05f6"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f313a05537979d36357213af2536ef31865f4863fd060184f79faf89a7e5c6ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2def3a6d7826fad5b3ff8fdd86156742436d2a93fc1bb9415dfbb209e92489b"
    sha256 cellar: :any_skip_relocation, monterey:       "14085a8a08fc30f922912b10880315f2aee4c694a397e2b67527a4e84306769b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b61a50a95de65885df5f5c87fe622fbf9199065f9940f3e509aa4ca21a8ae874"
    sha256 cellar: :any_skip_relocation, catalina:       "9a7bba31ebfeb1e9ff19738db93320fabb1120af8c6d39787bfa23cdc861c3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff955b3124197d5db7ab098179b09d31e5b1d242e4835f545f582af87606c5fd"
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
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
