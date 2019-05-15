require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.7.2/pandoc-2.7.2.tar.gz"
  sha256 "2080b3bf83e4a1fd4984fc1143da6d18a565a2fc63d7abf0091d7234ff5154e2"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "061df034a6db511da9527d4854e125c16facb65bd0220255e35083f7f244666a" => :mojave
    sha256 "e5b22a9027074824151f20a99cabca01e1a5188732fc5b63887ce08e654c11c6" => :high_sierra
    sha256 "91f38ecb0cfe35b1e8f687226710e1a348d7dcdf67c71cb209688a5875d9f11d" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      install_cabal_package
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
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
