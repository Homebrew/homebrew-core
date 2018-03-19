require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1.3/pandoc-2.1.3.tar.gz"
  sha256 "4e0e9a891293f71a0d1309bbc5736e27601761888d9785ee19d8a4649b047008"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    rebuild 1
    sha256 "741e5f9aef81e96439a1fcdef9641496c1d61d9f0aa9d080466eeb8d5e6a8ea2" => :high_sierra
    sha256 "4eadff30e83ee9b400b401de2704bb568c4281b32b9b239dea76e9f1235567c9" => :sierra
    sha256 "49b3d66d076464a8de0b2f85c7fbda155a5224c1a6fe11c9af14c74f6744edab" => :el_capitan
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
