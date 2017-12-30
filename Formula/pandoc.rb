require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.6/pandoc-2.0.6.tar.gz"
  sha256 "f2f236e91986b522510c7ea8212c1641da6006d0acec3e6b587a4e4faf3612ee"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3b227234198cc274441677dcba80783d77cf757ee22bdf99e3b3c908ddac0905" => :high_sierra
    sha256 "da1455f22c8c8cfd907a24c6c61c727eab8f1ef8137cc9dbe152bacb9b4ae660" => :sierra
    sha256 "67f2f19df5a3bc7f44f80393bd14830c3a128f0a0d9ee6d32794ae9e4c79044a" => :el_capitan
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
