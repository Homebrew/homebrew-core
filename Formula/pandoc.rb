require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.2/pandoc-2.0.2.tar.gz"
  sha256 "b79fd769939760e74dddb253d9325ee1c19899d075e458db4d22ff0b0beef9f9"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "eafd5d994a2d165487c092a036b67772d92f942e1fea5593539bf3cca5bccd7d" => :high_sierra
    sha256 "64db981bf49563d08306e0e2c3b22331774b879b1e5d67a2614eb6ab405556ad" => :sierra
    sha256 "7b544a7ef604b4b78fbe307e6ba65c7034fd0bcb0bc08befe020c954b43b8c40" => :el_capitan
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
