require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.2.1/pandoc-1.19.2.1.tar.gz"
  sha256 "08692f3d77bf95bb9ba3407f7af26de7c23134e7efcdafad0bdaf9050e2c7801"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "5ab23c0459890d90097da4b841f98d8e6481f8d537c7350b842a8db7d31e52a6" => :sierra
    sha256 "8f68c968de86ebc5dfd166d65f3893f3c9240a9742a7495f34a5a4835c04e26f" => :el_capitan
    sha256 "9476aee7cc8376a6667188eac81cd4c0ebd15fa752fc53f7377c48967b6b46f7" => :yosemite
  end

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
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
