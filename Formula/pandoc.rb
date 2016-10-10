require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.17.2/pandoc-1.17.2.tar.gz"
  sha256 "81727d054dfb26de816ea59ed541ebaf60d66d440012c12ec02f9c2b02fee8ec"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "c22facb7c3190b20c81a750bf54fa076aaaa0c3baf3837d199fb724c456e6f4a" => :sierra
    sha256 "57337c49f118e146afb7219a4b25928ea4600ce6baf1896bed740053d8d52865" => :el_capitan
    sha256 "13056c5ba9d30304588ac26b8a7f3db790a942c0026da47a4f248bb49bfd819b" => :yosemite
    sha256 "0cf6c4e41715083d283ae83af3e7d4f5618d82d65b9b395fcf7c43d3faf6e62c" => :mavericks
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
