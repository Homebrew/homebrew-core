require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.2/pandoc-2.0.2.tar.gz"
  sha256 "b79fd769939760e74dddb253d9325ee1c19899d075e458db4d22ff0b0beef9f9"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "407815280e7b755e2c9592a37cc7874859247bcf3c1638c044cceaf824da6b80" => :high_sierra
    sha256 "6257961464c053809ee3c2576a4bda8902e93e6ef88c7c3ccbc8a745ab581189" => :sierra
    sha256 "66cad758772484d89c42f81876773eb7a776dc8f6e2844ea5188b05cc04f5ada" => :el_capitan
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
