require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1.3/pandoc-2.1.3.tar.gz"
  sha256 "4e0e9a891293f71a0d1309bbc5736e27601761888d9785ee19d8a4649b047008"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3ecb5b28f384bd99a5d6d36bc26b385f2253fc78ae4ae3ba51c1dba45602563f" => :high_sierra
    sha256 "24b9663a1262cecacae23c409b08147f4eb846915271a37f4d4ad9ecc102c6d7" => :sierra
    sha256 "06fe015a2c8c43a667e4e796135241eaa2984a012044d2934cac30465b95887b" => :el_capitan
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
