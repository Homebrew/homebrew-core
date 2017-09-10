require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.2.4/pandoc-1.19.2.4.tar.gz"
  sha256 "bbe08c1f7fcfea98b899f9956c04159d493a26f65d3350aa6579aa5b93203556"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3ca0dde718eed1db1d6620b2fac477166592cb93ff1c24a4b07dcf0d1b4317b0" => :sierra
    sha256 "480274969f8e4fac50a4258412ba07c32de463e955bc2e82b51b3ea79e2078a4" => :el_capitan
    sha256 "c061767f8f1c07e7e60b1b3920f324a8530469f53b0206a6de5901859bf02eb0" => :yosemite
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
