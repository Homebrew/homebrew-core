require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.2.2/pandoc-2.2.2.tar.gz"
  sha256 "0c371bed505b61685389773817e3a23fd0f0df3212d3b764eedfcd5365357965"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3e14ae13d451490f931a168939397987ce5934cd687b0f48d4b6c920d1a0d129" => :high_sierra
    sha256 "2d58d3cdb84a1f95682d9b5b4f15d4881824886784ef9c79434e4500c911aa5c" => :sierra
    sha256 "c57339f27a8a8039d5639d305f59e0b399403ae5c7a96e747425d3084f19191e" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
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
