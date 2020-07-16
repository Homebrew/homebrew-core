require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.10/pandoc-2.10.tar.gz"
  sha256 "41162a292f90a96ace8ef9394337a170cc756a20a63bb60a2a6bd0b5fa255286"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be40069cb95d3de8fdf16e311998bb1e6315a635d7e93183ba771a12d3f548cd" => :catalina
    sha256 "b1f1dea0254517166a8575c5e2b2ee279ccbdb682578d62ba66a91011595fa78" => :mojave
    sha256 "98bc7e09e12d87d7c0cd372ab658bc767516c841d00502535e4dc05e0607565f" => :high_sierra
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
