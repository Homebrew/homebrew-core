require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.2/pandoc-1.19.2.tar.gz"
  sha256 "8a87110f60e6412a4cae68b27e1647d029b73bb7f1794a62a3477a0df1bbbbbc"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "673f242e8f15282f30b41d9cc1e67854f7fa1ab00886fe76ae4e749652b95c92" => :sierra
    sha256 "a3c3e4926097c683db33ebb0817995ffaa1e58921c8a684f0362ec9a288680a1" => :el_capitan
    sha256 "b9ef7dd88a8a9469081af3bef856f5405d451c5deec8102969beedb72de319cc" => :yosemite
  end

  depends_on "ghc" => :build
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
