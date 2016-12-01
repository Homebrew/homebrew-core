require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19/pandoc-1.19.tar.gz"
  sha256 "227a5a70c8510e95f7dcc4dc1af3ebd9fb3efd252e5cbbda38aa1b9eb178f638"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "be78c573ba9c168e1dd209bebeb9cf369dcbc18deae287a22ae4f2537ab04eda" => :sierra
    sha256 "df0208a170809267cb03f13c147ede9ee24c96ed25d42f4201570873821c3217" => :el_capitan
    sha256 "23e234d77f0f3d236e57eab448e93726a3acceff9d875c4e1cfb16c9bb821252" => :yosemite
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
