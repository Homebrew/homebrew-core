require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17.1/pandoc-1.17.1.tar.gz"
  sha256 "5978baaf664ce254b508108a6be9d5a11a2c2ac61462ae85286be2ecdb010c86"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "466fe8c81ee3464943990baad04de7094402fd1a74c4f1cf392b7d9853bd1ed6" => :el_capitan
    sha256 "38fb459f1f287b13544cb17ff0311c0b637ea1cbc8908eee71dd368f6cd93d2d" => :yosemite
    sha256 "49d9f1e3d09902a6ad23d0938ca01ac2e6df8b3b440ad228e357f00fd8d9e044" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
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
