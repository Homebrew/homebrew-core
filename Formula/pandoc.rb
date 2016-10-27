require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.18/pandoc-1.18.tar.gz"
  sha256 "3ea4b977f31d71dedd99a4584a895659efbbab02b00fdc9daaf7781787ce4e92"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "21b4394ba8cd7d4f1f0aabb5364afde865def0dfe3e96fbc494651222e534371" => :sierra
    sha256 "9c89c158ccc700be0bc20c659809e1078cd9077eab55e39ddffba7164cb5eb17" => :el_capitan
    sha256 "8a7106dfc402b7bb63519e1a5b8ce9439bf084a145ffa30d4fe9183659f8b4a5" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<-EOS.undent
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<-EOS.undent
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
