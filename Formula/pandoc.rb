require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.7.2/pandoc-2.7.2.tar.gz"
  sha256 "2080b3bf83e4a1fd4984fc1143da6d18a565a2fc63d7abf0091d7234ff5154e2"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    rebuild 1
    sha256 "9b72d0209f028c8f14ca8a078f838898b65fc188d9f65d0267e50f864050f663" => :mojave
    sha256 "cd0e7ba4201a3fefa90dae0ec70e66dd427a4d5104de749e56bed0ea28e3af8f" => :high_sierra
    sha256 "81f9bc5ce14964ff46fc2cb6afa624a3105258e4c3cb5eae635525c4b860aac7" => :sierra
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
