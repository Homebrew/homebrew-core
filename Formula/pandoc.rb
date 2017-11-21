require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.3/pandoc-2.0.3.tar.gz"
  sha256 "d814e087da1f06774353d0da14b744966c480bb49af7d6167f0010edd92cb3ee"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "d972ab0f5c659ba48fd09e9ea592e9b6993a081b784511a9148f919f5ebfb142" => :high_sierra
    sha256 "378d68e2676709082a3e37e179122c549328c2cab2088888a1818c19858dfe2a" => :sierra
    sha256 "f845c2417142fa4af83ee8af658080c9e8efcef1d5039a1d566a4aa5ff0b4796" => :el_capitan
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
