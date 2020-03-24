require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.9.2.1/pandoc-2.9.2.1.tar.gz"
  sha256 "c26d35372cf8b7d53062c9c495c0bca2ee370891c2349d3798a44f9ca33bdf57"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "949ccbac7e6449b1a46e5127e584ff5523f5ec0c7a813a82d42c222597326dfd" => :catalina
    sha256 "bbe146924e557a77da1cf14022460da030cb6cce0151f1830f4d4373049758cb" => :mojave
    sha256 "a319ffdeeec5b1630a35c7cc61ae69337eb39ad735d1b6665a5cf8e6ab8783f6" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    cabal_sandbox do
      install_cabal_package :flags => ["embed_data_files"]
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
