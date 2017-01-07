require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.1/pandoc-1.19.1.tar.gz"
  sha256 "9d22db0a1536de0984f4a605f1a28649e68d540e6d892947d9644987ecc4172a"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "bbec3be0f16d69d0d1b00aec395cde226eeebdeff3fbeedb55f0bc72e594c935" => :sierra
    sha256 "65ecbc93d80f906879748ccf869e830ec00f876f773e936112980c4560531576" => :el_capitan
    sha256 "6b6afdd595a240d6d51b6cd3621c2ed262c8693633189d752273d682725e7b97" => :yosemite
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
