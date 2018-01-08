require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1/pandoc-2.1.tar.gz"
  sha256 "c2bbfacb3a15716353b63fd719e0041985b56499f40323d5c9ce9c81165a4aa4"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "dc1ff1f8c489fead6a0d8fb962afc926b00a585421072014542bf0b30f025ca8" => :high_sierra
    sha256 "1ac7fd1a1e99fbb09d0b70b20d3eaf78f5ee4906c37df7027e9d63943f3a6e34" => :sierra
    sha256 "341970aaa517bacb99129bd8c39282bdbf73c9d8467910d447d63dea3863ab93" => :el_capitan
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
