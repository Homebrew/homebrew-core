require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17.1/pandoc-1.17.1.tar.gz"
  sha256 "5978baaf664ce254b508108a6be9d5a11a2c2ac61462ae85286be2ecdb010c86"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    revision 1
    sha256 "53c9837b6b76491dce1129439292380ef3ecc68fc9913603877f4f7a37d4f816" => :el_capitan
    sha256 "effbea891713dd5f1949d467ce382d8e546e9e8d8ad3f25195b4b3ffaeb33d6a" => :yosemite
    sha256 "f99da891cc5c15ba6f882868399f81c440cdbce12f4b30d305aa55c0d6a68624" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

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
