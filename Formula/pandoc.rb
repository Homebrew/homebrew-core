require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.1/pandoc-2.0.1.tar.gz"
  sha256 "ab3e598ea6aa54606188f1e74cdd722da95599a54e87629a97b181a3c58e8701"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "26f944469ffff80864c7ccc9c5f3524c56de561441bdf66bc1f9a17a1d35f560" => :high_sierra
    sha256 "ad172114713cce8a3cdf24aab2806aa0b831322259b8e5815c2d81c89b4816b6" => :sierra
    sha256 "5973be74647bd2d06715e6e8ab1093a75957c8499d3fc434c99aa2b02e0a80c2" => :el_capitan
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
