require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.9.1.1/pandoc-2.9.1.1.tar.gz"
  sha256 "9d21c5efe2074f9b3097a20e0798de9d8b89a86a1ce04a307f476c7b4aa3816d"
  revision 1
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "1adc3019366def3f0368083a8220b6f0cc61347b832eb52535527f5ce28d23e7" => :catalina
    sha256 "f10f1af1eae6fccf77d78d478cf128cfca12d9edbd5856f80dedd5aaf5ff9c11" => :mojave
    sha256 "81fbc2783d28098aa44c24a7e26bbe30f60ccdc69043a752132aad77c36f3db5" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
